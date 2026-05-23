import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import 'keypad.dart';

class ScrTrades extends StatefulWidget {
  const ScrTrades({super.key});
  @override
  State<ScrTrades> createState() => _ScrTradesState();
}

class _ScrTradesState extends State<ScrTrades> {
  String _mm = '1847';
  int _denom = 16;

  void _onKey(String k) {
    setState(() {
      if (k == '⌫') {
        _mm = _mm.length > 1 ? _mm.substring(0, _mm.length - 1) : '0';
      } else if (k == '.') {
        if (!_mm.contains('.')) _mm = '$_mm.';
      } else if ('0123456789'.contains(k)) {
        if (_mm == '0') {
          _mm = k;
        } else if (_mm.length < 7) {
          _mm = '$_mm$k';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final numMm = double.tryParse(_mm) ?? 0;
    final frac = mmToFtInFrac(numMm, denom: _denom == 0 ? 16 : _denom);
    final alsoFt = numMm / 304.8;
    final alsoIn = numMm / 25.4;

    const denoms = [
      ['1/8″', 8], ['1/16″', 16], ['1/32″', 32], ['1/64″', 64], ['decimal', 0],
    ];

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 4),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const Text('Trades ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18, color: C.ink)),
                const Doodle(DoodleKind.saw, size: 18, color: C.sky),
                const Spacer(),
                const Stamp(text: 'compound', color: C.sky, rotate: 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: denoms.map((d) {
                final active = _denom == d[1];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: SkChip(
                    height: 28,
                    fill: active ? C.ink : Colors.transparent,
                    stroke: active ? C.ink : C.inkFaint,
                    textColor: active ? C.paper : C.inkSoft,
                    onTap: () => setState(() => _denom = d[1] as int),
                    child: Text(d[0] as String, style: const TextStyle(fontSize: 11)),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SkBox(
              padding: const EdgeInsets.all(14),
              double_: true,
              radius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('decimal',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      const Text('millimetres',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: C.inkSoft)),
                    ],
                  ),
                  Text(_mm.isEmpty ? '0' : _mm,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 46,
                          color: C.ink,
                          height: 1,
                          letterSpacing: -1.6)),
                  const Text('mm',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: C.inkSoft)),
                  const SizedBox(height: 10),
                  const SkDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('compound',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      Text('ft-in-frac · 1/${_denom == 0 ? 'dec' : _denom}″',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: C.inkSoft)),
                    ],
                  ),
                  if (_denom == 0)
                    Text('${fmt(alsoFt, decimals: 4)} ft',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 36,
                            color: C.terra,
                            height: 1))
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${frac.feet}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 38,
                                color: C.terra,
                                letterSpacing: -1)),
                        const Text('′',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: C.inkSoft)),
                        const SizedBox(width: 6),
                        Text('${frac.inches}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 38,
                                color: C.terra,
                                letterSpacing: -1)),
                        const Text('″',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: C.inkSoft)),
                        if (frac.num > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${frac.num}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: C.terra,
                                        height: 1)),
                                Container(
                                  height: 1.5,
                                  color: C.terra,
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 16,
                                ),
                                Text('${frac.den}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: C.terra,
                                        height: 1)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'also: ${fmt(alsoFt, decimals: 3)} ft · ${fmt(alsoIn, decimals: 2)} in · ${fmt(numMm / 1000, decimals: 4)} m',
                      style: GoogleFonts.caveat(
                          fontSize: 14, color: C.inkSoft),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Keypad(onKey: _onKey),
        ],
      ),
    );
  }
}
