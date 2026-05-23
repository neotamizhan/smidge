import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import 'keypad.dart';

class ScrCooking extends StatefulWidget {
  const ScrCooking({super.key});
  @override
  State<ScrCooking> createState() => _ScrCookingState();
}

class _ScrCookingState extends State<ScrCooking> {
  String _ingredient = 'flour_ap';
  String _cups = '2.5';
  String _target = 'g';
  bool _showPicker = false;
  String _search = '';

  void _onKey(String k) {
    setState(() {
      if (k == '⌫') {
        _cups = _cups.length > 1 ? _cups.substring(0, _cups.length - 1) : '0';
      } else if (k == '.') {
        if (!_cups.contains('.')) _cups = '$_cups.';
      } else if ('0123456789'.contains(k)) {
        if (_cups == '0') {
          _cups = k;
        } else {
          _cups = '$_cups$k';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ing = kIngredients.firstWhere((i) => i.id == _ingredient,
        orElse: () => kIngredients.first);
    final cval = double.tryParse(_cups) ?? 0;
    final result = cookingConvert(cval, _ingredient, _target);
    const targets = [
      ['g', 'grams'], ['oz', 'oz'], ['lb', 'lb'], ['kg', 'kg'], ['mL', 'mL'],
    ];

    if (_showPicker) {
      final filtered = _search.isEmpty
          ? kIngredients
          : kIngredients.where((i) => i.name.toLowerCase().contains(_search.toLowerCase())).toList();
      return Paper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 18, 8),
              child: Row(
                children: [
                  BackBtn(onTap: () => setState(() => _showPicker = false)),
                  const SizedBox(width: 4),
                  const Text('Choose ingredient',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: C.ink)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SkBox(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 42,
                radius: 14,
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'flour, sugar, butter…',
                    hintStyle: TextStyle(fontSize: 14, color: C.inkFaint),
                  ),
                  style: const TextStyle(fontSize: 14, color: C.ink),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: filtered.map((i) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      _ingredient = i.id;
                      _showPicker = false;
                    }),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: C.inkFaint.withValues(alpha: 0.33))),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(i.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: C.ink)),
                          Text('1 US cup = ${i.gramsPerCup.toInt()} g',
                              style: const TextStyle(
                                  fontSize: 11, color: C.inkSoft)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 6),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const SizedBox(width: 4),
                const Text('In the kitchen ',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18, color: C.ink)),
                const Doodle(DoodleKind.cup, size: 18, color: C.mustard),
                const Spacer(),
                const Stamp(text: 'density-aware', color: C.mustard, rotate: 4),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SkBox(
              padding: const EdgeInsets.all(12),
              radius: 14,
              onTap: () => setState(() => _showPicker = true),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: C.mustard.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: Doodle(DoodleKind.cup, size: 24)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ingredient',
                            style: GoogleFonts.caveat(
                                fontSize: 14,
                                color: C.inkFaint)),
                        Text(ing.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: C.ink)),
                      ],
                    ),
                  ),
                  const Doodle(DoodleKind.arrow, size: 20, color: C.inkSoft),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                      Text('from',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      const Text('US cups',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: C.inkSoft)),
                    ],
                  ),
                  Text(_cups.isEmpty ? '0' : _cups,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 44,
                          color: C.ink,
                          height: 1,
                          letterSpacing: -1.5)),
                  const SizedBox(height: 10),
                  const SkDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('to',
                          style: GoogleFonts.caveat(
                              fontSize: 17, color: C.inkFaint)),
                      Row(
                        children: targets.map((t) {
                          final on = _target == t[0];
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: SkChip(
                              height: 22,
                              fill: on ? C.ink : Colors.transparent,
                              stroke: on ? C.ink : C.inkFaint,
                              textColor: on ? C.paper : C.inkSoft,
                              onTap: () => setState(() => _target = t[0]),
                              child: Text(t[0], style: const TextStyle(fontSize: 10)),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Text(fmt(result, decimals: 1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 44,
                          color: C.terra,
                          height: 1,
                          letterSpacing: -1.5)),
                  Text(_target,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: C.inkSoft)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SkBox(
              padding: const EdgeInsets.all(10),
              radius: 12,
              stroke: C.inkFaint,
              fill: C.mustard.withValues(alpha: 0.1),
              dashed: true,
              child: Text(
                '1 US cup ${ing.name.split(',').first.toLowerCase()} ≈ ${ing.gramsPerCup.toInt()} g. '
                'Density per USDA FoodData Central.',
                style: const TextStyle(fontSize: 12, color: C.inkSoft, height: 1.45),
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
