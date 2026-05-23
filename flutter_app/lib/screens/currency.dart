import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smidge/data/fx_service.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import 'keypad.dart';

class ScrCurrency extends StatefulWidget {
  const ScrCurrency({super.key});
  @override
  State<ScrCurrency> createState() => _ScrCurrencyState();
}

class _ScrCurrencyState extends State<ScrCurrency> {
  String _from = 'USD';
  String _to = 'INR';
  String _amount = '250';

  Map<String, double> _rates = {};
  DateTime? _lastUpdated;
  bool _loading = false;
  bool _isLive = false;

  void _onKey(String k) {
    setState(() {
      if (k == '⌫') {
        _amount =
            _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else if (k == '.') {
        if (!_amount.contains('.')) _amount = '$_amount.';
      } else if ('0123456789'.contains(k)) {
        if (_amount == '0') {
          _amount = k;
        } else if (_amount.length < 10) {
          _amount = '$_amount$k';
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    if (!mounted) return;
    setState(() => _loading = true);
    _rates = await FxService.getRates();
    _lastUpdated = await FxService.lastUpdated();
    _isLive = _lastUpdated != null;
    if (!mounted) return;
    setState(() => _loading = false);
  }

  double _rate(String sym) => _rates[sym] ?? kCurrencies[sym]?.rate ?? 1.0;

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final val = double.tryParse(_amount) ?? 0;
    final fromRate = _rate(_from);
    final toRate = _rate(_to);
    final result = val * (toRate / fromRate);

    final recents = kCurrencies.entries
        .where((e) => e.key != _from && e.key != _to)
        .take(5)
        .toList();

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 4),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const Text('Currency ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: C.ink)),
                const Doodle(DoodleKind.globe, size: 18, color: C.sage),
                const Spacer(),
                _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: C.terra),
                      )
                    : GestureDetector(
                        onTap: () async {
                          await FxService.clearCache();
                          _loadRates();
                        },
                        child: Stamp(
                          text: _isLive ? '↻ live' : 'static · snapshot',
                          color: _isLive ? C.sage : C.terra,
                          rotate: -8,
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SkBox(
              padding: const EdgeInsets.all(16),
              double_: true,
              radius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${kCurrencies[_from]!.flag} $_from',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: C.ink)),
                      GestureDetector(
                        onTap: () => setState(() {
                          final t = _from;
                          _from = _to;
                          _to = t;
                        }),
                        child: const Doodle(DoodleKind.swap,
                            size: 20, color: C.inkSoft),
                      ),
                    ],
                  ),
                  Text('${kCurrencies[_from]!.sym} $_amount',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 42,
                          color: C.ink,
                          height: 1,
                          letterSpacing: -1.6)),
                  const SizedBox(height: 12),
                  const SkDivider(),
                  const SizedBox(height: 12),
                  Text('${kCurrencies[_to]!.flag} $_to',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: C.ink)),
                  Text('${kCurrencies[_to]!.sym} ${fmt(result, decimals: 2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 42,
                          color: C.terra,
                          height: 1,
                          letterSpacing: -1.6)),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '1 $_from ≈ ${kCurrencies[_to]!.sym} ${fmt(toRate / fromRate, decimals: 4)}'
                      ' · ${_isLive && _lastUpdated != null ? 'live · ${_timeAgo(_lastUpdated!)}' : 'static snapshot'}',
                      style: GoogleFonts.caveat(fontSize: 14, color: C.inkSoft),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
            child: Text('other currencies',
                style: GoogleFonts.caveat(fontSize: 18, color: C.inkFaint)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: recents.map((e) {
                final r = val * (_rate(e.key) / fromRate);
                return GestureDetector(
                  onTap: () => setState(() => _to = e.key),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: C.inkFaint.withValues(alpha: 0.33))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${e.value.flag} ${e.key}  ·  ${e.value.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: C.ink)),
                              Text(
                                  '1 $_from = ${fmt(_rate(e.key) / fromRate, decimals: 4)} ${e.key}',
                                  style: TextStyle(
                                      fontSize: 11, color: C.inkFaint)),
                            ],
                          ),
                        ),
                        Text('${e.value.sym} ${fmt(r, decimals: 2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: C.ink)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Keypad(onKey: _onKey),
        ],
      ),
    );
  }
}
