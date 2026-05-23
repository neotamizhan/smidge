import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../data/units.dart';
import '../state/app_state.dart';

class ScrUnitPicker extends StatefulWidget {
  final AppState state;
  final InputSide side;
  const ScrUnitPicker({super.key, required this.state, required this.side});
  @override
  State<ScrUnitPicker> createState() => _ScrUnitPickerState();
}

class _ScrUnitPickerState extends State<ScrUnitPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final cat = kCategories[widget.state.category];
    if (cat == null) return const Paper(child: SizedBox());
    final currentUnit = widget.side == InputSide.from
        ? widget.state.fromUnit
        : widget.state.toUnit;
    final entries = cat.units.entries.where((e) {
      if (_search.isEmpty) return true;
      return '${e.value.name} ${e.value.sym}'
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
                const SizedBox(width: 4),
                Text('Pick a unit · ${cat.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16, color: C.ink)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SkBox(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              stroke: C.ink,
              fill: const Color(0x99FFFFFF),
              height: 42,
              radius: 14,
              child: Row(
                children: [
                  Icon(Icons.search, size: 16, color: C.inkSoft),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Search ${cat.name.toLowerCase()} units…',
                        hintStyle: const TextStyle(fontSize: 14, color: C.inkFaint),
                      ),
                      style: const TextStyle(fontSize: 14, color: C.ink),
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
              children: entries.map((e) {
                final isCurrent = e.key == currentUnit;
                return GestureDetector(
                  onTap: () {
                    widget.state.setUnit(widget.side, e.key);
                    Navigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: C.inkFaint.withValues(alpha: 0.33))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(e.value.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: C.ink)),
                              ),
                              if (isCurrent)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text('✓ current',
                                      style: TextStyle(
                                          fontSize: 11, color: C.terra)),
                                ),
                            ],
                          ),
                        ),
                        Text(e.value.sym,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: C.inkFaint)),
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
