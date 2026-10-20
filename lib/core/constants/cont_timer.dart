import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Exact3DGlossyTimer extends StatefulWidget {
  final int initialSeconds;
  const Exact3DGlossyTimer({Key? key, this.initialSeconds = 5}) : super(key: key);

  @override
  _Exact3DGlossyTimerState createState() => _Exact3DGlossyTimerState();
}

class _Exact3DGlossyTimerState extends State<Exact3DGlossyTimer> {
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String text = _timeLeft.toString().padLeft(2, '0');

    return Center(
      child: CustomPaint(
        size: const Size(260, 140),
        painter: Realistic3DNumberPainter(text: text),
      ),
    );
  }
}

class Realistic3DNumberPainter extends CustomPainter {
  final String text;
  Realistic3DNumberPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      fontSize: 120,
      fontWeight: FontWeight.w900,
      fontFamily: 'Arial', // Smooth rounded edges ke liye
      letterSpacing: -1.0,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 1. Bottom Dark Rim (Base Outline Shadow)
    final baseDarkRim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..color = const Color(0xFF6A0000);

    // 2. Main Red Tube Paint (Radiant Fill)
    final mainBodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.6),
        radius: 1.2,
        colors: [
          Color(0xFFFF3333), // Top Center Highlight
          Color(0xFFE60000), // Mid Plastic Red
          Color(0xFF990000), // Bottom Dark Red
        ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(rect);

    // 3. Inner Dark Bevel Shadow (Volume Create karne ke liye)
    final innerBevelShadow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = const Color(0xFF500000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // 4. White Top Specular Reflection (Glass/Glossy Shine)
    final glossHighlight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = Colors.white.withOpacity(0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    // --- DRAWING LAYERS ---

    // Layer 1: Dark Outer Base
    _drawTextLayer(canvas, textPainter, offset, baseDarkRim);

    // Layer 2: Main Red 3D Body
    _drawTextLayer(canvas, textPainter, offset, mainBodyPaint);

    // Layer 3: Inner Bottom Bevel
    canvas.save();
    canvas.translate(0, 2);
    _drawTextLayer(canvas, textPainter, offset, innerBevelShadow);
    canvas.restore();

    // Layer 4: Top Glossy Curved Highlight (Upper-Left Reflection)
    canvas.save();
    canvas.translate(-1.5, -2);
    _drawTextLayer(canvas, textPainter, offset, glossHighlight);
    canvas.restore();
  }

  void _drawTextLayer(Canvas canvas, TextPainter painter, Offset offset, Paint paint) {
    painter.text = TextSpan(
      text: text,
      style: painter.text!.style!.copyWith(foreground: paint),
    );
    painter.layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant Realistic3DNumberPainter oldDelegate) {
    return oldDelegate.text != text;
  }
}