import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/units.dart';
import '../state/app_state.dart';
import 'cooking.dart';
import 'medical.dart';
import 'trades.dart';
import 'currency.dart';

class ScrLibrary extends StatefulWidget {
  final AppState state;
  const ScrLibrary({super.key, required this.state});
  @override
  State<ScrLibrary> createState() => _ScrLibraryState();
}

class _ScrLibraryState extends State<ScrLibrary> {
  String _search = '';

  String _displayName(String id) {
    final cat = kCategories[id];
    if (cat != null) return cat.name;
    return id[0].toUpperCase() + id.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final cats = [
      ...kCategories.values.map((cat) {
        final count = cat.units.length;
        final unitWord = cat.id == 'temperature' ? 'scales' : 'units';
        final symbols = cat.units.values.map((u) => u.sym).take(4).join(', ');
        final suffix = cat.units.length > 4 ? '…' : '';
        return [cat.id,cat.icon,cat.color,'$count $unitWord · $symbols$suffix',];
      }),

      const ['cooking',DoodleKind.cup,C.mustard,'19 ingredients · density-aware'],
      const ['medical', DoodleKind.heart, C.terra, 'Glucose · clinical ranges'],
      const ['trades', DoodleKind.saw, C.sky, 'Compound ft-in-fraction'],
      const ['currency', DoodleKind.globe, C.sage,'14 currencies · static rates'],
    ];

    final filtered = _search.isEmpty
        ? cats
        : cats.where((c) {
            final id = c[0] as String;
            final name = _displayName(id);
            final desc = c[3] as String;
            final units = kCategories[id]?.units.values
                    .map((u) => '${u.name} ${u.sym}')
                    .join(' ') ??
                '';
            return '$name $units $desc'
                .toLowerCase()
                .contains(_search.toLowerCase());
          }).toList();

    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 8),
            child: Row(
              children: [
                BackBtn(onTap: () => Navigator.pop(context)),
                const SizedBox(width: 6),
                const Text('The library',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: C.ink,
                        letterSpacing: -0.5)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SkBox(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              stroke: C.inkFaint,
              fill: const Color(0x66FFFFFF),
              height: 38,
              radius: 14,
              child: Row(
                children: [
                  Icon(Icons.search, size: 16, color: C.inkSoft),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Search units & categories…',
                        hintStyle: TextStyle(fontSize: 13, color: C.inkFaint),
                      ),
                      style: const TextStyle(fontSize: 13, color: C.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: filtered.map((c) {
                final id = c[0] as String;
                final kind = c[1] as DoodleKind;
                final color = c[2] as Color;
                final desc = c[3] as String;
                final name = _displayName(id);
                return GestureDetector(
                  onTap: () => _open(id),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: C.inkFaint.withValues(alpha: 0.4))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: color, width: 1.4),
                          ),
                          child: Center(child: Doodle(kind, size: 26)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: C.ink)),
                              const SizedBox(height: 2),
                              Text(desc,
                                  style: const TextStyle(
                                      fontSize: 11, color: C.inkSoft)),
                            ],
                          ),
                        ),
                        Doodle(DoodleKind.arrow, size: 20, color: C.inkFaint),
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

  void _open(String id) {
    Widget? page;
    switch (id) {
      case 'cooking': page = const ScrCooking(); break;
      case 'medical': page = const ScrMedical(); break;
      case 'trades': page = const ScrTrades(); break;
      case 'currency': page = const ScrCurrency(); break;
    }
    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    } else {
      widget.state.setCategory(id);
      Navigator.pop(context);
    }
  }
}
