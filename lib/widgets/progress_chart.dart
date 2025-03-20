import 'package:flutter/material.dart';
import 'dart:math';

class ProgressChart extends StatelessWidget {
  final List<double> data;
  final bool isAverage;

  const ProgressChart({super.key, required this.data, this.isAverage = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: ChartPainter(
        data: data,
        color: Theme.of(context).colorScheme.primary,
        isAverage: isAverage,
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool isAverage;

  ChartPainter({
    required this.data,
    required this.color,
    this.isAverage = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Line paint
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    // Dot paint
    final dotPaint =
        Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

    // Glow paint (for the area below the line)
    final glowPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.5), color.withOpacity(0.0)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    double maxValue = data.reduce(max);
    if (maxValue == 0) maxValue = 1; // Avoid division by zero

    final double xStep = size.width / (data.length - 1);
    final List<Offset> points = [];

    // Calculate all points first
    for (int i = 0; i < data.length; i++) {
      final double normalizedValue = data[i] / maxValue;
      final double y = size.height - (normalizedValue * size.height);
      points.add(Offset(i * xStep, y));
    }

    // Start paths
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      fillPath.moveTo(points.first.dx, size.height); // Start at bottom left
      fillPath.lineTo(
        points.first.dx,
        points.first.dy,
      ); // Line up to first point
    }

    // Draw smooth curves between points
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // Calculate control points for cubic Bezier curve
      final double controlPointX1 = p0.dx + (p1.dx - p0.dx) / 3;
      final double controlPointX2 = p0.dx + 2 * (p1.dx - p0.dx) / 3;

      path.cubicTo(controlPointX1, p0.dy, controlPointX2, p1.dy, p1.dx, p1.dy);

      fillPath.cubicTo(
        controlPointX1,
        p0.dy,
        controlPointX2,
        p1.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Complete fill path back to bottom right then bottom left
    if (points.isNotEmpty) {
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.lineTo(points.first.dx, size.height);
    }

    // Draw the fill for glow effect
    canvas.drawPath(fillPath, glowPaint);

    // Draw the line
    canvas.drawPath(path, paint);

    // Draw average line if requested
    if (isAverage && data.isNotEmpty) {
      final double sum = data.reduce((a, b) => a + b);
      final double avg = sum / data.length;
      final double avgY = size.height - (avg / maxValue * size.height);

      final avgPaint =
          Paint()
            ..color = Colors.red.shade300
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;

      final dashPath = Path();
      dashPath.moveTo(0, avgY);
      dashPath.lineTo(size.width, avgY);

      canvas.drawPath(dashPath, avgPaint);
    }

    // Draw dots at data points
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.color != color;
}
