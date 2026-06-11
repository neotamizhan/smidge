import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/smidge_glyph.dart';
import '../design/doodles.dart';
import '../data/units.dart';
import '../data/convert.dart';
import '../data/format.dart';
import '../state/app_state.dart';
import 'keypad.dart';
import 'multi.dart';
import 'library.dart';
import 'unit_picker.dart';
import 'pins.dart';
import 'cooking.dart';
import 'medical.dart';
import 'trades.dart';
import 'currency.dart';
import 'settings.dart';

class ScrHome extends StatelessWidget {
  final AppState state;
  const ScrHome({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cat = kCategories[state.category] ?? kCategories['length']!;
    final visibleCategories = state.preferredCategories.isEmpty
        ? kCategories.entries.toList()
        : kCategories.entries.where((e) {
            return state.preferredCategories.contains(e.key);
          }).toList();
    final units = cat.units;
    final fromU = units[state.fromUnit];
    final toU = units[state.toUnit];
    final fromSym = fromU?.sym ?? state.fromUnit;
    final toSym = toU?.sym ?? state.toUnit;
    final fromName = fromU?.name ?? state.fromUnit;
    final toName = toU?.name ?? state.toUnit;

    final parsedVal = evalExpr(state.expression) ?? double.tryParse(state.expression);
    final isFromActive = state.inputSide == InputSide.from;

    String fromVal, toVal;
    if (parsedVal != null && parsedVal.isFinite) {
      if (isFromActive) {
        fromVal = state.expression;
        toVal = fmt(convert(parsedVal, state.fromUnit, state.toUnit, state.category));
      } else {
        toVal = state.expression;
        fromVal = fmt(convert(parsedVal, state.toUnit, state.fromUnit, state.category));
      }
    } else {
      fromVal = isFromActive ? state.expression : '';
      toVal = !isFromActive ? state.expression : '';
    }

    return Paper(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 6),
            child: Row(
              children: [
                const SmidgeGlyph(size: 30),
                const SizedBox(width: 8),
                const SmidgeMark(),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScrPins(state: state))),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Doodle(DoodleKind.pin, size: 22, color: C.inkSoft),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScrLibrary(state: state))),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: SizedBox(
                      width: 20, height: 14,
                      child: CustomPaint(painter: _HamPainter()),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScrSettings(state: state))),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.settings_outlined, size: 20, color: C.inkSoft),
                  ),
                ),
              ],
            ),
          ),
          _PinnedShelf(state: state),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: visibleCategories.map((e) {
                final id = e.key;
                final c = e.value;
                final active = id == state.category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SkChip(
                    height: 30,
                    fill: active ? C.ink : Colors.transparent,
                    stroke: active ? C.ink : C.inkFaint,
                    textColor: active ? C.paper : C.ink,
                    onTap: () => state.setCategory(id),
                    child: Text(c.name),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SkBox(
              padding: const EdgeInsets.all(18),
              double_: true,
              radius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FROM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('from',
                          style: GoogleFonts.caveat(
                              fontSize: 18, color: C.inkFaint)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScrUnitPicker(state: state, side: InputSide.from),
                          ),
                        ),
                        child: Text('$fromName ↓',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: C.inkSoft)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => state.setSide(InputSide.from),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              (isFromActive ? state.expression : fromVal).isEmpty
                                  ? '0'
                                  : (isFromActive ? state.expression : fromVal),
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: C.ink,
                                height: 1,
                                letterSpacing: -2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(fromSym,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: C.inkSoft)),
                          ),
                          if (isFromActive) const _BlinkCursor(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: SkDivider()),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: state.swap,
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(36, 36),
                                painter: _SwapCirclePainter(),
                              ),
                              const Doodle(DoodleKind.swap, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: SkDivider()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // TO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('to',
                          style: GoogleFonts.caveat(
                              fontSize: 18, color: C.inkFaint)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScrUnitPicker(state: state, side: InputSide.to),
                          ),
                        ),
                        child: Text('$toName ↓',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: C.inkSoft)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => state.setSide(InputSide.to),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              (!isFromActive ? state.expression : toVal).isEmpty
                                  ? '0'
                                  : (!isFromActive ? state.expression : toVal),
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                color: C.terra,
                                height: 1,
                                letterSpacing: -2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(toSym,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: C.inkSoft)),
                          ),
                          if (!isFromActive) const _BlinkCursor(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: C.inkFaint, style: BorderStyle.solid)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _alsoText(state.category, state.fromUnit, state.toUnit, parsedVal),
                          style: GoogleFonts.caveat(
                              fontSize: 14, color: C.inkSoft),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          SkChip(
                            height: 22,
                            fill: state.exprMode ? C.terra : Colors.transparent,
                            stroke: state.exprMode ? C.terra : C.inkFaint,
                            textColor: state.exprMode ? C.paper : C.inkSoft,
                            onTap: state.toggleExpr,
                            child: const Text('= math', style: TextStyle(fontSize: 10)),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScrMulti(state: state)),
                            ),
                            child: Text('all →',
                                style: TextStyle(fontSize: 11, color: C.inkFaint)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Keypad(onKey: state.onKey, exprMode: state.exprMode),
        ],
      ),
    );
  }

  static String _alsoText(String cat, String from, String to, double? v) {
    if (v == null || !v.isFinite) return '';
    final c = kCategories[cat];
    if (c == null || c.special) return '';
    final extras = c.units.keys.where((k) => k != from && k != to).take(2);
    return extras
        .map((u) => '${fmt(convert(v, from, u, cat))} ${c.units[u]!.sym}')
        .join(' · ');
  }
}

class _BlinkCursor extends StatefulWidget {
  const _BlinkCursor();
  @override
  State<_BlinkCursor> createState() => _BlinkCursorState();
}

class _BlinkCursorState extends State<_BlinkCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Opacity(
            opacity: _ctrl.value < 0.5 ? 1 : 0,
            child: Container(width: 2, height: 26, color: C.terra),
          );
        },
      ),
    );
  }
}

class _HamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = C.inkSoft
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (final y in [size.height * 0.15, size.height * 0.5, size.height * 0.85]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SwapCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 2;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      r,
      Paint()..color = C.paper..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      r,
      Paint()
        ..color = C.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinnedShelf extends StatelessWidget {
  final AppState state;
  const _PinnedShelf({required this.state});

  static const _defs = {
    'temp':    {'a': '°F', 'b': '°C', 'cat': 'temperature', 'from': 'F', 'to': 'C', 'doodle': DoodleKind.therm, 'color': C.terra},
    'flour':   {'a': 'cup', 'b': 'g',  'cat': 'cooking', 'doodle': DoodleKind.cup, 'color': C.mustard},
    'glucose': {'a': 'mg/dL', 'b': 'mmol/L', 'cat': 'medical', 'doodle': DoodleKind.drop, 'color': C.sage},
    'dist':    {'a': 'mi', 'b': 'km', 'cat': 'length', 'from': 'mi', 'to': 'km', 'doodle': DoodleKind.ruler, 'color': C.sky},
    'weight':  {'a': 'lb', 'b': 'kg', 'cat': 'mass', 'from': 'lb', 'to': 'kg', 'doodle': DoodleKind.scale, 'color': C.inkSoft},
  };

  @override
  Widget build(BuildContext context) {
    final show = state.pins.take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: show.map((id) {
          final d = _defs[id];
          if (d == null) return const Expanded(child: SizedBox());
          final active = d['cat'] == state.category;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SkBox(
                height: 46,
                padding: const EdgeInsets.all(6),
                stroke: active ? C.ink : C.inkFaint,
                fill: active ? C.paper : const Color(0x05000000),
                onTap: () {
                  final cat = d['cat'] as String;
                  if (['cooking','medical','trades','currency'].contains(cat)) {
                    _openVertical(context, cat);
                  } else {
                    state.setCategory(cat, from: d['from'] as String?, to: d['to'] as String?);
                  }
                },
                child: Row(
                  children: [
                    Doodle(d['doodle'] as DoodleKind, size: 20),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(d['a'] as String,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: C.ink,
                                  height: 1.1)),
                          Text('↓ ${d['b']}',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: C.inkFaint,
                                  height: 1.1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _openVertical(BuildContext context, String cat) {
    Widget page;
    switch (cat) {
      case 'cooking': page = const ScrCooking(); break;
      case 'medical': page = const ScrMedical(); break;
      case 'trades': page = const ScrTrades(); break;
      case 'currency': page = const ScrCurrency(); break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
