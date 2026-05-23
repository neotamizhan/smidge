import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/units.dart';
import '../state/app_state.dart';
import 'pins.dart';

class ScrSettings extends StatelessWidget {
  final AppState state;
  const ScrSettings({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final groups = [
      ('House style', [
        ('Default system', _systemLabel(state.system), DoodleKind.scale, null),
        ('Decimal places', '${state.decimals}', DoodleKind.pencil, null),
        ('Show sci notation', 'above 1e7', DoodleKind.bolt, null),
      ]),
      ('Pantry', [
        ('Active categories', '${kCategories.length} total', DoodleKind.star, null),
        ('My pinned three', '${state.pins.length} / 3', DoodleKind.pin,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScrPins(state: state)))),
        ('Cooking · default cup', 'US (236 mL)', DoodleKind.cup, null),
        ('Medical · thresholds', 'ADA default', DoodleKind.heart, null),
      ]),
      ('About', [
        ('Privacy', 'no tracking', DoodleKind.heart, null),
        ('Made with care · v1.0', '', DoodleKind.star, null),
      ]),
    ];

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
                const Text('Settings',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: C.ink,
                        letterSpacing: -0.5)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: groups.map((g) {
                final sec = g.$1;
                final items = g.$2;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                        child: Text(sec,
                            style: GoogleFonts.caveat(
                                                                fontSize: 16,
                                color: C.inkFaint)),
                      ),
                      SkBox(
                        padding: EdgeInsets.zero,
                        radius: 16,
                        child: Column(
                          children: items.asMap().entries.map((entry) {
                            final it = entry.value;
                            final isLast = entry.key == items.length - 1;
                            return GestureDetector(
                              onTap: it.$4,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLast
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: C.inkFaint.withValues(alpha: 0.33)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Doodle(it.$3, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(it.$1,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: C.ink)),
                                    ),
                                    Text(it.$2,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: C.inkSoft,
                                            fontWeight: FontWeight.w500)),
                                    if (it.$4 != null)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text('›',
                                            style: TextStyle(
                                                fontSize: 14, color: C.inkFaint)),
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
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _systemLabel(String s) {
    switch (s) {
      case 'metric': return 'Metric';
      case 'imperial': return 'Imperial';
      default: return 'Both';
    }
  }
}
