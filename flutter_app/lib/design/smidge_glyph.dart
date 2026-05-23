import 'package:flutter/material.dart';
import 'colors.dart';
import 'wobble.dart';

/// The Smidge mark — a hand-drawn ruler with eleven ticks (the centre "hero"
/// tick is the smidge) over an ink baseline, with a terracotta dot of ink
/// sitting just above the hero tick, all inside a wobble-bordered squircle.
///
/// Ported pixel-for-pixel from "Smidge - Logo.html" (the SmidgeGlyph component,
/// a 100-unit viewBox). The whole thing is drawn in the original 0–100
/// coordinate space and scaled to [size] via a canvas transform.
class SmidgeGlyph extends StatelessWidget {
  final double size;
  final Color ink;
  final Color dot;

  /// Fill colour of the squircle. Null = transparent (mono / tintable use).
  final Color? paper;

  /// Draw the rounded-square frame (outer squircle + inner dashed squircle).
  final bool frame;

  /// Draw the ruler ticks + baseline.
  final bool ticks;

  const SmidgeGlyph({
    super.key,
    this.size = 120,
    this.ink = C.ink,
    this.dot = C.terra,
    this.paper = C.paper,
    this.frame = true,
    this.ticks = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SmidgeGlyphPainter(
          ink: ink,
          dot: dot,
          paper: paper,
          frame: frame,
          ticks: ticks,
        ),
      ),
    );
  }
}

class _SmidgeGlyphPainter extends CustomPainter {
  final Color ink;
  final Color dot;
  final Color? paper;
  final bool frame;
  final bool ticks;

  _SmidgeGlyphPainter({
    required this.ink,
    required this.dot,
    required this.paper,
    required this.frame,
    required this.ticks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Work in the original 100-unit viewBox; scale to the target size.
    canvas.save();
    canvas.scale(size.width / 100.0, size.height / 100.0);

    if (frame) {
      // Outer squircle: rect 3,3,94,94 r=22, paper fill + ink stroke 2.4.
      Wobble.drawRRect(
        canvas,
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 3, 94, 94),
          const Radius.circular(22),
        ),
        fill: paper,
        stroke: ink,
        strokeWidth: 2.4,
        amplitude: 0.8,
      );
      // Inner dashed squircle: rect 6,6,88,88 r=20, ink 0.8 @ 45%, dash 1.4/2.
      Wobble.drawRRect(
        canvas,
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(6, 6, 88, 88),
          const Radius.circular(20),
        ),
        stroke: ink.withValues(alpha: 0.45),
        strokeWidth: 0.8,
        dashed: true,
        dashOn: 1.4,
        dashOff: 2,
        amplitude: 0.8,
      );
    }

    if (ticks) {
      // Eleven hand-ruled ticks: long, short, long, short… centre tick is hero.
      for (int i = 0; i < 11; i++) {
        final x = 16 + i * 6.8;
        final tall = i % 2 == 0;
        final isHero = i == 5;
        Wobble.drawLine(
          canvas,
          Offset(x, isHero ? 38 : 48),
          Offset(x, tall ? 62 : 58),
          stroke: ink,
          strokeWidth: isHero ? 2.4 : 1.4,
          amplitude: 0.8,
        );
      }
      // Baseline across the ticks.
      Wobble.drawLine(
        canvas,
        const Offset(14, 62),
        const Offset(86, 62),
        stroke: ink,
        strokeWidth: 1.6,
        amplitude: 0.8,
      );
    }

    // The smidge — a single fat dot of ink at the centred tall tick.
    final dotPath = Wobble.apply(
      Path()..addOval(Rect.fromCircle(center: const Offset(50, 32), radius: 4.8)),
      amplitude: 0.6,
    );
    canvas.drawPath(dotPath, Paint()..color = dot..style = PaintingStyle.fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SmidgeGlyphPainter old) =>
      old.ink != ink ||
      old.dot != dot ||
      old.paper != paper ||
      old.frame != frame ||
      old.ticks != ticks;
}
