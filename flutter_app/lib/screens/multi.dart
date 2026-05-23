import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../data/units.dart';
import '../data/convert.dart';
import '../data/format.dart';
import '../state/app_state.dart';

class ScrMulti extends StatelessWidget {
  final AppState state;
  const ScrMulti({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cat = kCategories[state.category];
    if (cat == null) return const Paper(child: SizedBox());
    final val = evalExpr(state.expression) ?? double.tryParse(state.expression) ?? 1.0;
    final units = cat.units;
    final from = state.fromUnit;

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 8),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const SizedBox(width: 4),
                Text(cat.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18, color: C.ink)),
                const SizedBox(width: 8),
                Text(' · all at once',
                    style: GoogleFonts.caveat(
                        fontSize: 16, color: C.inkFaint)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
            child: SkBox(
              padding: const EdgeInsets.all(14),
              stroke: C.terra,
              fill: C.terra.withValues(alpha: 0.05),
              radius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('input',
                      style: GoogleFonts.caveat(
                          fontSize: 16, color: C.inkSoft)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(val.isFinite ? fmt(val) : state.expression,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 40,
                              color: C.ink,
                              height: 1,
                              letterSpacing: -1.5)),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(units[from]?.name ?? from,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: C.inkSoft)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SkDivider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: units.entries.where((e) => e.key != from).map((e) {
                final result = val.isFinite
                    ? (cat.special
                        ? convertTemp(val, from, e.key)
                        : convert(val, from, e.key, state.category))
                    : double.nan;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: C.inkFaint.withValues(alpha: 0.33))),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(e.value.name,
                            style: const TextStyle(
                                fontSize: 13,
                                color: C.inkSoft,
                                fontWeight: FontWeight.w500)),
                      ),
                      Text(fmt(result),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: C.ink,
                              letterSpacing: -0.4)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(e.value.sym,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 11, color: C.inkFaint)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
