import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import '../state/app_state.dart';
import 'cooking.dart';
import 'medical.dart';

class ScrPins extends StatelessWidget {
  final AppState state;
  const ScrPins({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final pinDefs = [
      {'id':'temp','cat':'temperature','from':'F','to':'C','a':'°F','b':'°C',
       'doodle': DoodleKind.therm, 'accent': C.terra, 'note':'temperature', 'val':'72'},
      {'id':'flour','cat':'cooking','doodle': DoodleKind.cup,
       'accent': C.mustard, 'note':'all-purpose flour', 'a':'cup', 'b':'g', 'val':'1'},
      {'id':'glucose','cat':'medical','doodle': DoodleKind.drop,
       'accent': C.sage, 'note':'blood glucose', 'a':'mg/dL', 'b':'mmol/L', 'val':'94'},
      {'id':'dist','cat':'length','from':'mi','to':'km','a':'mi','b':'km',
       'doodle': DoodleKind.ruler, 'accent': C.sky, 'note':'distance', 'val':'1'},
      {'id':'weight','cat':'mass','from':'lb','to':'kg','a':'lb','b':'kg',
       'doodle': DoodleKind.scale, 'accent': C.inkSoft, 'note':'mass', 'val':'1'},
    ];

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 6),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const SmidgeMark(),
                const Spacer(),
                const Doodle(DoodleKind.pin, size: 20, color: C.terra),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('your three pins',
                    style: GoogleFonts.caveat(
                        fontSize: 22, color: C.inkSoft)),
                Text('tap to open · long-press to swap',
                    style: TextStyle(fontSize: 11, color: C.inkFaint)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: pinDefs.map((p) {
                final v = double.tryParse(p['val'] as String) ?? 0;
                String a = p['val'] as String, b = '';
                final cat = p['cat'] as String;
                if (cat == 'cooking') {
                  b = fmt(cookingConvert(v, 'flour_ap', 'g'), decimals: 0);
                } else if (cat == 'medical') {
                  b = fmt(convertGlucose(v, 'mgdL', 'mmolL'), decimals: 2);
                } else {
                  b = fmt(convert(v, p['from'] as String, p['to'] as String, cat));
                }
                final accent = p['accent'] as Color;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SkBox(
                    padding: const EdgeInsets.all(14),
                    radius: 18,
                    stroke: accent,
                    double_: true,
                    fill: const Color(0x66FFFFFF),
                    onTap: () {
                      if (cat == 'cooking') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ScrCooking()));
                      } else if (cat == 'medical') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ScrMedical()));
                      } else {
                        state.setCategory(cat,
                            from: p['from'] as String?, to: p['to'] as String?);
                        Navigator.popUntil(context, (r) => r.isFirst);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.11),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Doodle(p['doodle'] as DoodleKind, size: 30, color: accent),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${p['a']} → ${p['b']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: C.inkSoft,
                                      letterSpacing: 0.2)),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(a,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 28,
                                          color: C.ink,
                                          letterSpacing: -0.8,
                                          height: 1)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                                    child: Text(p['a'] as String,
                                        style: const TextStyle(
                                            fontSize: 12, color: C.inkSoft)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Text('→',
                                        style: TextStyle(
                                            fontSize: 16, color: C.inkFaint)),
                                  ),
                                  Text(b,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 28,
                                          color: accent,
                                          letterSpacing: -0.8,
                                          height: 1)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                                    child: Text(p['b'] as String,
                                        style: const TextStyle(
                                            fontSize: 12, color: C.inkSoft)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(p['note'] as String,
                                    style: GoogleFonts.caveat(
                                                                                fontSize: 14,
                                        color: C.inkFaint)),
                              ),
                            ],
                          ),
                        ),
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
}
