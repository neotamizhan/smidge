import 'package:flutter/material.dart';
import '../design/colors.dart';

class Keypad extends StatelessWidget {
  final void Function(String k) onKey;
  final bool exprMode;
  const Keypad({super.key, required this.onKey, this.exprMode = false});

  @override
  Widget build(BuildContext context) {
    final rows = exprMode
        ? const [
            ['7', '8', '9', '÷'],
            ['4', '5', '6', '×'],
            ['1', '2', '3', '−'],
            ['.', '0', '=', '+'],
          ]
        : const [
            ['7', '8', '9'],
            ['4', '5', '6'],
            ['1', '2', '3'],
            ['.', '0', '⌫'],
          ];

    final keypad = Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: row.map((k) {
                final accent = exprMode && k == '=';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => onKey(k),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        height: 50,
                        child: CustomPaint(
                          painter: _KeyPainter(accent: accent),
                          child: Center(
                            child: Text(
                              k,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: accent ? C.paper : C.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );

    if (!exprMode) return keypad;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: w * 0.045),
              child: GestureDetector(
                onTap: () => onKey('⌫'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.070,
                    vertical: w * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x73FFFFFF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: C.inkSoft, width: 1.2),
                  ),
                  child: Text(
                    '⌫',
                    style: TextStyle(
                      fontSize: (w * 0.055).clamp(18.0, 26.0),
                      fontWeight: FontWeight.w600,
                      color: C.ink,
                    ),
                  ),
                ),
              ),
            ),
            keypad,
          ],
        );
      },
    );
  }
}

class _KeyPainter extends CustomPainter {
  final bool accent;
  _KeyPainter({required this.accent});
  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final rrect = RRect.fromRectAndRadius(r, const Radius.circular(6));
    // We can't use Wobble here as easily because we want the fill
    final paint = Paint()..color = accent ? C.terra : const Color(0x73FFFFFF);
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = accent ? C.terra : C.inkSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! _KeyPainter || oldDelegate.accent != accent;
}
