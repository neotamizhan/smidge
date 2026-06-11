import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/doodles.dart';
import '../data/convert.dart';
import '../data/format.dart';
import '../data/pin_defs.dart';
import '../state/app_state.dart';
import 'cooking.dart';
import 'medical.dart';

class ScrPins extends StatelessWidget {
  final AppState state;
  const ScrPins({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        // Pinned first, in the user's order, then the remaining candidates.
        final pinned = state.pins
            .map((id) => kPinDefById[id])
            .whereType<PinDef>()
            .toList();
        final rest =
            kPinDefs.where((p) => !state.pins.contains(p.id)).toList();
        final defs = [...pinned, ...rest];

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
                        style:
                            GoogleFonts.caveat(fontSize: 22, color: C.inkSoft)),
                    Text('tap to open · star to pin your three',
                        style: TextStyle(fontSize: 11, color: C.inkFaint)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children:
                      defs.map((p) => _card(context, p)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card(BuildContext context, PinDef p) {
    final isPinned = state.pins.contains(p.id);
    final v = double.tryParse(p.sampleVal) ?? 0;
    final a = p.sampleVal;
    String b;
    if (p.cat == 'cooking') {
      b = fmt(cookingConvert(v, 'flour_ap', 'g'), decimals: 0);
    } else if (p.cat == 'medical') {
      b = fmt(convertGlucose(v, 'mgdL', 'mmolL'), decimals: 2);
    } else {
      b = fmt(convert(v, p.from!, p.to!, p.cat));
    }
    final accent = isPinned ? p.accent : C.inkFaint;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        key: Key('pin-card-${p.id}'),
        onLongPress: () => state.togglePin(p.id),
        child: SkBox(
          padding: const EdgeInsets.all(14),
          radius: 18,
          stroke: accent,
          double_: isPinned,
          fill: const Color(0x66FFFFFF),
          onTap: () => _open(context, p),
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
                  child: Doodle(p.doodle, size: 30, color: accent),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${p.a} → ${p.b}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: C.inkSoft,
                            letterSpacing: 0.2)),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
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
                          child: Text(p.a,
                              style: const TextStyle(
                                  fontSize: 12, color: C.inkSoft)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Text('→',
                              style:
                                  TextStyle(fontSize: 16, color: C.inkFaint)),
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
                            child: Text(p.b,
                                style: const TextStyle(
                                    fontSize: 12, color: C.inkSoft)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(p.note,
                          style: GoogleFonts.caveat(
                              fontSize: 14, color: C.inkFaint)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                key: Key('pin-star-${p.id}'),
                onTap: () => state.togglePin(p.id),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Doodle(DoodleKind.star,
                      size: 24, color: isPinned ? p.accent : C.inkFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, PinDef p) {
    if (p.cat == 'cooking') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ScrCooking()));
    } else if (p.cat == 'medical') {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ScrMedical()));
    } else {
      state.setCategory(p.cat, from: p.from, to: p.to);
      Navigator.popUntil(context, (r) => r.isFirst);
    }
  }
}
