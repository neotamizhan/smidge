import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design/colors.dart';
import '../design/sk_widgets.dart';
import '../design/smidge_glyph.dart';
import '../design/doodles.dart';

class ScrSplash extends StatelessWidget {
  const ScrSplash({super.key});
  @override
  Widget build(BuildContext context) {
    return Paper(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SmidgeGlyph(size: 132),
                const SizedBox(height: 22),
                const SmidgeMark(size: 44),
                const SizedBox(height: 10),
                const SkUnderline(width: 120),
                const SizedBox(height: 4),
                Text(
                  'just a smidge.',
                  style: GoogleFonts.caveat(
                    fontSize: 24,
                    color: C.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Text(
              'LOADING THE PANTRY…',
              style: TextStyle(
                fontSize: 11,
                color: C.inkFaint,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrWelcome extends StatelessWidget {
  final VoidCallback onNext;
  const ScrWelcome({super.key, required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Paper(
      child: Stack(
        children: [
          Positioned(
            top: 60,
            right: 14,
            child: Opacity(opacity: 0.6, child: const Doodle(DoodleKind.beaker, size: 44)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const SmidgeGlyph(size: 64),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 38,
                      color: C.ink,
                      height: 1,
                      letterSpacing: -1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Hello,\nwelcome to '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          clipBehavior: Clip.none,
                          children: [
                            const Text(
                              'smidge',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 38,
                                color: C.ink,
                                letterSpacing: -1.4,
                              ),
                            ),
                            const Positioned(
                              left: 0,
                              bottom: -6,
                              child: SkUnderline(width: 120),
                            ),
                          ],
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: 240,
                  child: Text(
                    'A tiny, careful unit converter. No ads, no chatter — just the answer, at the speed you need it.',
                    style: TextStyle(
                      fontSize: 15,
                      color: C.inkSoft,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text('3 quick taps to set up',
                        style: GoogleFonts.caveat(
                            fontSize: 20, color: C.inkSoft)),
                    const SizedBox(width: 6),
                    const Doodle(DoodleKind.arrow, size: 24),
                  ],
                ),
                const SizedBox(height: 14),
                SkButton(
                  big: true,
                  height: 56,
                  width: double.infinity,
                  onPressed: onNext,
                  child: const Text("Let's begin"),
                ),
                const SizedBox(height: 14),
                Center(
                  child: GestureDetector(
                    onTap: onNext,
                    child: Text(
                      "Skip — I'm in a hurry",
                      style: TextStyle(fontSize: 13, color: C.inkFaint),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScrPickCats extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;
  final VoidCallback onNext;
  const ScrPickCats({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onNext,
  });

  static const _cats = [
    ['length', 'Length', 'ruler', 'sky'],
    ['mass', 'Mass', 'scale', 'mustard'],
    ['volume', 'Volume', 'beaker', 'sage'],
    ['temperature', 'Temperature', 'therm', 'terra'],
    ['cooking', 'Cooking', 'cup', 'mustard'],
    ['currency', 'Currency', 'globe', 'sage'],
    ['medical', 'Medical', 'heart', 'terra'],
    ['trades', 'Trades', 'saw', 'sky'],
    ['data', 'Data', 'bolt', 'inkSoft'],
  ];

  static DoodleKind _kind(String k) => DoodleKind.values.firstWhere((e) => e.name == k);

  @override
  Widget build(BuildContext context) {
    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
            child: Text('step one · the pantry',
                style: GoogleFonts.caveat(
                    fontSize: 18, color: C.inkFaint)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'What do you measure?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: C.ink,
                height: 1.05,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
            child: Text('Tick a few. You can always add more.',
                style: TextStyle(fontSize: 13, color: C.inkSoft)),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.65,
                physics: const BouncingScrollPhysics(),
                children: _cats.map((c) {
                  final id = c[0];
                  final name = c[1];
                  final kind = _kind(c[2]);
                  final on = selected.contains(id);
                  return GestureDetector(
                    onTap: () => onToggle(id),
                    child: SkBox(
                      padding: const EdgeInsets.all(10),
                      stroke: on ? C.terra : C.inkSoft,
                      fill: on ? C.terra.withValues(alpha: 0.08) : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Doodle(kind, size: 28),
                              _Check(on: on),
                            ],
                          ),
                          Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: C.ink)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            child: Row(
              children: [
                _Dot(filled: true),
                const SizedBox(width: 6),
                _Dot(),
                const SizedBox(width: 6),
                _Dot(),
                const Spacer(),
                SkButton(
                  width: 110,
                  onPressed: onNext,
                  child: const Text('Continue →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool filled;
  const _Dot({this.filled = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 4,
      decoration: BoxDecoration(
        color: filled ? C.ink : C.inkFaint.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  final bool on;
  const _Check({required this.on});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: on ? C.terra : C.inkFaint, width: 1.5),
        color: on ? C.terra : Colors.transparent,
      ),
      child: on
          ? const Center(
              child: Icon(Icons.check, size: 12, color: C.paper),
            )
          : null,
    );
  }
}

class ScrPref extends StatelessWidget {
  final String system;
  final ValueChanged<String> onChange;
  final VoidCallback onNext;
  const ScrPref({
    super.key,
    required this.system,
    required this.onChange,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final opts = [
      ['metric', 'Metric', 'g · ml · km · °C', DoodleKind.beaker],
      ['imperial', 'Imperial', 'oz · cup · mi · °F', DoodleKind.cup],
      ['both', 'A bit of both', 'show both at once', DoodleKind.swap],
    ];
    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
            child: Text('step two · house style',
                style: GoogleFonts.caveat(
                    fontSize: 18, color: C.inkFaint)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Which side of the\nkitchen are you on?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: C.ink,
                height: 1.05,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: opts.map((o) {
                  final on = system == o[0];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => onChange(o[0] as String),
                      child: SkBox(
                        height: 68,
                        padding: const EdgeInsets.all(14),
                        stroke: on ? C.terra : C.inkSoft,
                        fill: on ? C.terra.withValues(alpha: 0.07) : null,
                        child: Row(
                          children: [
                            Doodle(o[3] as DoodleKind, size: 32),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(o[1] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: C.ink)),
                                  const SizedBox(height: 2),
                                  Text(o[2] as String,
                                      style: const TextStyle(
                                          fontSize: 12, color: C.inkSoft)),
                                ],
                              ),
                            ),
                            _Check(on: on),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            child: Row(
              children: [
                _Dot(filled: false),
                const SizedBox(width: 6),
                _Dot(filled: true),
                const SizedBox(width: 6),
                _Dot(),
                const Spacer(),
                SkButton(width: 110, onPressed: onNext, child: const Text('Continue →')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScrPinThree extends StatelessWidget {
  final Set<String> pins;
  final void Function(String) onToggle;
  final VoidCallback onDone;
  const ScrPinThree({
    super.key,
    required this.pins,
    required this.onToggle,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final opts = [
      ['temp', '°F', '°C', DoodleKind.therm, C.terra],
      ['flour', 'cup', 'g · flour', DoodleKind.cup, C.mustard],
      ['glucose', 'mg/dL', 'mmol/L', DoodleKind.drop, C.sage],
      ['dist', 'mi', 'km', DoodleKind.ruler, C.sky],
      ['weight', 'lb', 'kg', DoodleKind.scale, C.inkSoft],
    ];
    return Paper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 30, 22, 0),
            child: Text('step three · the shortcut shelf',
                style: GoogleFonts.caveat(
                    fontSize: 18, color: C.inkFaint)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "Pin three you'll use\nmost often.",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: C.ink,
                height: 1.05,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: opts.map((o) {
                  final id = o[0] as String;
                  final on = pins.contains(id);
                  final color = o[4] as Color;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () => onToggle(id),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Doodle(o[3] as DoodleKind, size: 26),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: C.ink,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                      text: o[1] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  TextSpan(
                                      text: '  ↔  ',
                                      style: TextStyle(color: C.inkFaint)),
                                  TextSpan(
                                      text: o[2] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: CustomPaint(
                              painter: _StarPainter(filled: on, color: color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
            child: Row(
              children: [
                _Dot(),
                const SizedBox(width: 6),
                _Dot(),
                const SizedBox(width: 6),
                _Dot(filled: true),
                const Spacer(),
                SkButton(
                  width: 130,
                  fill: C.terra,
                  onPressed: onDone,
                  child: const Text('Start measuring'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final bool filled;
  final Color color;
  _StarPainter({required this.filled, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final path = Path();
    // Same star path as the on-screen pin: 5-pointed
    final pts = [
      [13, 4],
      [15, 11],
      [22, 11],
      [16, 15],
      [18, 22],
      [13, 18],
      [8, 22],
      [10, 15],
      [4, 11],
      [11, 11],
    ];
    for (int i = 0; i < pts.length; i++) {
      final x = pts[i][0] * s / 26;
      final y = pts[i][1] * s / 26;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    if (filled) {
      canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = filled ? color : C.inkFaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) =>
      old.filled != filled || old.color != color;
}
