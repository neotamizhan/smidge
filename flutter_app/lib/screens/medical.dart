import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import 'keypad.dart';

class ScrMedical extends StatefulWidget {
  const ScrMedical({super.key});
  @override
  State<ScrMedical> createState() => _ScrMedicalState();
}

class _ScrMedicalState extends State<ScrMedical> {
  String _value = '94';
  String _inputUnit = 'mgdL';

  void _onKey(String k) {
    setState(() {
      if (k == '⌫') {
        _value = _value.length > 1 ? _value.substring(0, _value.length - 1) : '0';
      } else if (k == '.') {
        if (!_value.contains('.')) _value = '$_value.';
      } else if ('0123456789'.contains(k)) {
        if (_value == '0') {
          _value = k;
        } else if (_value.length < 6) {
          _value = '$_value$k';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final numVal = double.tryParse(_value) ?? 0;
    final actualMgdL =
        _inputUnit == 'mgdL' ? numVal : numVal * kGlucoseFactor;
    final converted = _inputUnit == 'mgdL'
        ? fmt(convertGlucose(numVal, 'mgdL', 'mmolL'), decimals: 2)
        : fmt(convertGlucose(numVal, 'mmolL', 'mgdL'), decimals: 0);
    final range = glucoseRange(actualMgdL);
    final fromSym = _inputUnit == 'mgdL' ? 'mg/dL' : 'mmol/L';
    final toSym = _inputUnit == 'mgdL' ? 'mmol/L' : 'mg/dL';

    final segs = [
      [20, C.sky, '< 70', 'low'],
      [35, C.sage, '70–99', 'normal'],
      [20, C.mustard, '100–125', 'pre-diab'],
      [25, C.terra, '≥ 126', 'diabetic'],
    ];
    final markerPct = range.pct.clamp(2, 98).toDouble();

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 4),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const Text('Medical ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18, color: C.ink)),
                const Doodle(DoodleKind.drop, size: 18, color: C.terra),
                const Spacer(),
                const Stamp(text: 'not a diagnosis', color: C.terra, rotate: -4),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: ['Glucose', 'HbA1c', 'Cholest.', 'Creat.', 'Trig.']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: SkChip(
                          height: 28,
                          fill: e.key == 0 ? C.terra : Colors.transparent,
                          stroke: e.key == 0 ? C.terra : C.inkFaint,
                          textColor: e.key == 0 ? C.paper : C.inkSoft,
                          child: Text(e.value, style: const TextStyle(fontSize: 11)),
                        ),
                      ))
                  .toList(),
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
                      Text('blood glucose',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      GestureDetector(
                        onTap: () => setState(() {
                          _inputUnit = _inputUnit == 'mgdL' ? 'mmolL' : 'mgdL';
                        }),
                        child: Text('$fromSym ↕',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: C.inkSoft)),
                      ),
                    ],
                  ),
                  Text(_value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 46,
                          color: C.ink,
                          height: 1,
                          letterSpacing: -1.6)),
                  Text(fromSym,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: C.inkSoft)),
                  const SizedBox(height: 10),
                  const SkDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('=',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      Text(toSym,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: C.inkSoft)),
                    ],
                  ),
                  Text(converted,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 46,
                          color: C.terra,
                          height: 1,
                          letterSpacing: -1.6)),
                  Text(toSym,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: C.inkSoft)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('where this sits · fasting (ADA)',
                    style: GoogleFonts.caveat(
                        fontSize: 16, color: C.inkFaint)),
                const SizedBox(height: 8),
                LayoutBuilder(builder: (ctx, c) {
                  return SizedBox(
                    height: 54,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Row(
                            children: segs
                                .map((s) => Expanded(
                                      flex: s[0] as int,
                                      child: Container(
                                          height: 18,
                                          color: (s[1] as Color)
                                              .withValues(alpha: 0.85)),
                                    ))
                                .toList(),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: c.maxWidth * markerPct / 100 - 1,
                          child: Container(width: 2, height: 28, color: C.ink),
                        ),
                        Positioned(
                          top: -5,
                          left: c.maxWidth * markerPct / 100 - 5,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: C.ink,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            children: segs.map((s) {
                              return Expanded(
                                flex: s[0] as int,
                                child: Column(
                                  children: [
                                    Text(s[3] as String,
                                        style: TextStyle(
                                            color: s[1] as Color,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9.5)),
                                    Text(s[2] as String,
                                        style: const TextStyle(
                                            fontSize: 9.5, color: C.inkSoft)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: SkBox(
              padding: const EdgeInsets.all(10),
              radius: 12,
              fill: Color(range.colorValue).withValues(alpha: 0.1),
              stroke: Color(range.colorValue),
              dashed: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${range.label}.',
                      style: GoogleFonts.caveat(
                                                    fontSize: 17,
                          color: C.ink,
                          height: 1.1)),
                  const SizedBox(height: 3),
                  Text(
                    'ADA reference · educational only — discuss with your clinician.',
                    style: TextStyle(fontSize: 11, color: C.inkSoft),
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
