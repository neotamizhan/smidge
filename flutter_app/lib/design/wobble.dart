import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'colors.dart';

/// Wobble — turns a "clean" path into a hand-drawn one by sampling along
/// the path and perturbing each sample by a small random offset. Replaces
/// the SVG turbulence+displacementMap filter from the web version.
class Wobble {
  static final _rand = math.Random(7);

  static Path apply(Path path, {double amplitude = 0.7, double step = 4}) {
    final result = Path();
    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      if (length == 0) continue;
      var d = 0.0;
      var first = true;
      while (d < length) {
        final tan = metric.getTangentForOffset(d);
        if (tan == null) break;
        final pos = tan.position;
        final nx = -tan.vector.dy;
        final ny = tan.vector.dx;
        final amp = (_rand.nextDouble() - 0.5) * 2 * amplitude;
        final px = pos.dx + nx * amp;
        final py = pos.dy + ny * amp;
        if (first) {
          result.moveTo(px, py);
          first = false;
        } else {
          result.lineTo(px, py);
        }
        d += step;
      }
      final endTan = metric.getTangentForOffset(length);
      if (endTan != null) {
        final amp = (_rand.nextDouble() - 0.5) * 2 * amplitude;
        result.lineTo(
          endTan.position.dx + -endTan.vector.dy * amp,
          endTan.position.dy + endTan.vector.dx * amp,
        );
      }
      if (metric.isClosed) result.close();
    }
    return result;
  }

  static void drawRRect(
    Canvas canvas,
    RRect rrect, {
    Color? fill,
    Color stroke = Colors.black,
    double strokeWidth = 1.2,
    bool dashed = false,
    double amplitude = 0.7,
    double dashOn = 4,
    double dashOff = 4,
  }) {
    final path = Path()..addRRect(rrect);
    final wobbled = apply(path, amplitude: amplitude);
    if (fill != null) {
      canvas.drawPath(wobbled, Paint()..color = fill..style = PaintingStyle.fill);
    }
    final p = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (dashed) {
      _drawDashed(canvas, wobbled, p, on: dashOn, off: dashOff);
    } else {
      canvas.drawPath(wobbled, p);
    }
  }

  static void drawCircle(
    Canvas canvas,
    Offset center,
    double radius, {
    Color? fill,
    Color stroke = Colors.black,
    double strokeWidth = 1.2,
    double amplitude = 0.6,
  }) {
    final path = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final wobbled = apply(path, amplitude: amplitude);
    if (fill != null) {
      canvas.drawPath(wobbled, Paint()..color = fill..style = PaintingStyle.fill);
    }
    canvas.drawPath(
      wobbled,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  static void drawLine(
    Canvas canvas,
    Offset a,
    Offset b, {
    Color stroke = Colors.black,
    double strokeWidth = 1.4,
    double amplitude = 0.7,
  }) {
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy);
    final wobbled = apply(path, amplitude: amplitude);
    canvas.drawPath(
      wobbled,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  static void _drawDashed(Canvas canvas, Path path, Paint paint,
      {double on = 4, double off = 4}) {
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = math.min(d + on, metric.length);
        canvas.drawPath(metric.extractPath(d, next), paint);
        d = next + off;
      }
    }
  }
}

class SkUnderlinePainter extends CustomPainter {
  final Color color;
  SkUnderlinePainter({this.color = C.terra});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()..moveTo(0, h * 0.5);
    path.cubicTo(w * 0.2, h * 0.1, w * 0.3, h * 0.9, w * 0.5, h * 0.5);
    path.cubicTo(w * 0.7, h * 0.2, w * 0.85, h * 0.85, w, h * 0.5);
    canvas.drawPath(
      Wobble.apply(path, amplitude: 0.5),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SkDividerPainter extends CustomPainter {
  final Color color;
  SkDividerPainter({this.color = C.inkFaint});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(x + 4, size.height / 2), paint);
      x += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
