import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbitingDotsLoader extends StatefulWidget {
  final double size;
  final Color circleColor;
  final Color dotColor;
  final Duration duration;

  const OrbitingDotsLoader({
    Key? key,
    this.size = 50.0,
    this.circleColor = const Color(0x40D15391), // Thin outer circle border
    this.dotColor = const Color(0xFFE8428C),    // Pink glowing dots
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<OrbitingDotsLoader> createState() => _OrbitingDotsLoaderState();
}

class _OrbitingDotsLoaderState extends State<OrbitingDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // Continuous smooth rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _OrbitLoaderPainter(
            progress: _controller.value,
            circleColor: widget.circleColor,
            dotColor: widget.dotColor,
          ),
        );
      },
    );
  }
}

class _OrbitLoaderPainter extends CustomPainter {
  final double progress;
  final Color circleColor;
  final Color dotColor;

  _OrbitLoaderPainter({
    required this.progress,
    required this.circleColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    // 1. Circle Ring Radius
    final double circleRadius = radius * 0.55; // Inner ring standard size

    // 2. Dots Orbit Radius (Circle ke baahr placement)
    final double orbitRadius = radius * 0.85;  // Circle ke outer boundary par/baahar
    final double dotRadius = size.width * 0.10; // Dot ka size

    // 1. Draw Inner Thin Base Circle
    final Paint circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, circleRadius, circlePaint);

    // 2. Draw 3 Orbiting Dots OUTSIDE the circle (120 degrees apart)
    final Paint dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final double angleOffset = progress * 2 * math.pi;

    for (int i = 0; i < 3; i++) {
      final double angle = angleOffset + (i * 2 * math.pi / 3) - (math.pi / 2);

      // Dots position calculation with larger orbit radius
      final double dx = center.dx + orbitRadius * math.cos(angle);
      final double dy = center.dy + orbitRadius * math.sin(angle);

      // Glow Effect
      final Paint glowPaint = Paint()
        ..color = dotColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(dx, dy), dotRadius * 1.3, glowPaint);

      // Main Pink Dot
      canvas.drawCircle(Offset(dx, dy), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}