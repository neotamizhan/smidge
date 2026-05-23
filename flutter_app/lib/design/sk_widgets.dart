import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'wobble.dart';

/// Hand-drawn rounded rectangle container with optional double-stroke.
class SkBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? fill;
  final Color stroke;
  final double strokeWidth;
  final double radius;
  final bool double_;
  final bool dashed;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const SkBox({
    super.key,
    this.child,
    this.padding,
    this.fill,
    this.stroke = C.ink,
    this.strokeWidth = 1.4,
    this.radius = 14,
    this.double_ = false,
    this.dashed = false,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // The border (CustomPaint) is drawn at the outer edge; the padding sits
    // INSIDE the border so content is comfortably contained within the box
    // rather than sitting on the stroke.
    final w = SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SkBoxPainter(
          fill: fill,
          stroke: stroke,
          strokeWidth: strokeWidth,
          radius: radius,
          double_: double_,
          dashed: dashed,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
    if (onTap == null) return w;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: w);
  }
}

class _SkBoxPainter extends CustomPainter {
  final Color? fill;
  final Color stroke;
  final double strokeWidth;
  final double radius;
  final bool double_;
  final bool dashed;
  _SkBoxPainter({
    required this.fill,
    required this.stroke,
    required this.strokeWidth,
    required this.radius,
    required this.double_,
    required this.dashed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1.5, 1.5, size.width - 3, size.height - 3);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    Wobble.drawRRect(
      canvas,
      rrect,
      fill: fill,
      stroke: stroke,
      strokeWidth: strokeWidth,
      dashed: dashed,
      amplitude: 0.7,
    );
    if (double_) {
      final inner = RRect.fromRectAndRadius(
        rect.deflate(3),
        Radius.circular(radius - 2),
      );
      Wobble.drawRRect(
        canvas,
        inner,
        stroke: stroke.withValues(alpha: 0.45),
        strokeWidth: 0.9,
        amplitude: 0.6,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SkButton extends StatelessWidget {
  final Widget child;
  final Color fill;
  final Color textColor;
  final bool big;
  final VoidCallback? onPressed;
  final double? width;
  final double height;

  const SkButton({
    super.key,
    required this.child,
    this.fill = C.ink,
    this.textColor = C.paper,
    this.big = false,
    this.onPressed,
    this.width,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _SkBoxPainter(
            fill: fill,
            stroke: fill,
            strokeWidth: 1.6,
            radius: big ? 14 : 10,
            double_: false,
            dashed: false,
          ),
          child: Center(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: big ? 16 : 14,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class SkChip extends StatelessWidget {
  final Widget child;
  final Color fill;
  final Color stroke;
  final Color textColor;
  final double height;
  final VoidCallback? onTap;

  const SkChip({
    super.key,
    required this.child,
    this.fill = Colors.transparent,
    this.stroke = C.inkFaint,
    this.textColor = C.ink,
    this.height = 28,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _SkBoxPainter(
            fill: fill,
            stroke: stroke,
            strokeWidth: 1.2,
            radius: height / 2,
            double_: false,
            dashed: false,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkUnderline extends StatelessWidget {
  final double width;
  final Color color;
  const SkUnderline({super.key, this.width = 120, this.color = C.terra});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 10),
      painter: SkUnderlinePainter(color: color),
    );
  }
}

class SkDivider extends StatelessWidget {
  final Color color;
  const SkDivider({super.key, this.color = C.inkFaint});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: CustomPaint(painter: SkDividerPainter(color: color)),
    );
  }
}

class Stamp extends StatelessWidget {
  final String text;
  final Color color;
  final double rotate;
  const Stamp({super.key, required this.text, this.color = C.terra, this.rotate = 0});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          border: Border.all(color: color, width: 1.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class BackBtn extends StatelessWidget {
  final VoidCallback? onTap;
  const BackBtn({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: CustomPaint(
          size: const Size(20, 16),
          painter: _BackArrowPainter(),
        ),
      ),
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(0, size.height / 2);
    final p2 = Path()
      ..moveTo(6, 2)
      ..lineTo(0, size.height / 2)
      ..lineTo(6, size.height - 2);
    final paint = Paint()
      ..color = C.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(Wobble.apply(p, amplitude: 0.5), paint);
    canvas.drawPath(Wobble.apply(p2, amplitude: 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SmidgeMark extends StatelessWidget {
  final double size;
  const SmidgeMark({super.key, this.size = 22});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'smidge',
          style: TextStyle(
            color: C.ink,
            fontWeight: FontWeight.w800,
            fontSize: size,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: size * 0.18,
          height: size * 0.18,
          decoration: const BoxDecoration(
            color: C.terra,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Paper background (cream). Provides the Material ancestor every screen needs
/// (so Text renders without the debug yellow underline and TextField works),
/// the cream background, and keyboard-aware resizing for search screens.
class Paper extends StatelessWidget {
  final Widget child;
  const Paper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.paper,
      // Real top SafeArea: the OS status bar (time/signal/battery) shows through
      // and content sits below it — no fake in-app status bar needed.
      body: SafeArea(child: child),
    );
  }
}


class Caption extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const Caption(this.text, {super.key, this.color = C.inkSoft, this.size = 16});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.caveat(
                fontSize: size,
        color: color,
      ),
    );
  }
}
