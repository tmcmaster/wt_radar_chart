import 'dart:math' as math;
import 'dart:math' show cos, pi, sin;

import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double labelSpacing;

  const RadarChart({
    super.key,
    required this.ticks,
    required this.features,
    required this.data,
    this.reverseAxis = false,
    this.ticksTextStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    this.featuresTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    this.outlineColor = Colors.black,
    this.axisColor = Colors.grey,
    this.graphColors = const [
      Colors.green,
      Colors.blue,
      Colors.red,
      Colors.orange,
    ],
    this.sides = 0,
    this.labelSpacing = 5.0,
  });

  @override
  _RadarCharState createState() => _RadarCharState();
}

class _RadarCharState extends State<RadarChart> with SingleTickerProviderStateMixin {
  double fraction = 0;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: animationController,
      ),
    )..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });

    animationController.forward();
  }

  @override
  void didUpdateWidget(RadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _RadarChartPainter(
        widget.ticks,
        widget.features,
        widget.data,
        widget.reverseAxis,
        widget.ticksTextStyle,
        widget.featuresTextStyle,
        widget.outlineColor,
        widget.axisColor,
        widget.graphColors,
        widget.sides,
        fraction,
        widget.labelSpacing,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<List<num>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double fraction;
  final double labelSpacing;

  _RadarChartPainter(
    this.ticks,
    this.features,
    this.data,
    this.reverseAxis,
    this.ticksTextStyle,
    this.featuresTextStyle,
    this.outlineColor,
    this.axisColor,
    this.graphColors,
    this.sides,
    this.fraction,
    this.labelSpacing,
  );

  Path variablePath(Size size, double radius, int sides) {
    final path = Path();
    final angle = (math.pi * 2) / sides;

    final center = Offset(size.width / 2, size.height / 2);

    if (sides < 3) {
      path.addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
      );
    } else {
      final startPoint = Offset(radius * cos(-pi / 2), radius * sin(-pi / 2));

      path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      for (int i = 1; i <= sides; i++) {
        final x = radius * cos(angle * i - pi / 2) + center.dx;
        final y = radius * sin(angle * i - pi / 2) + center.dy;
        path.lineTo(x, y);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY) * 0.8;
    final scale = radius / ticks.last;

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    final ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    canvas.drawPath(variablePath(size, radius, sides), outlinePaint);
    final tickDistance = radius / (ticks.length);
    final tickLabels = reverseAxis ? ticks.reversed.toList() : ticks;

    if (reverseAxis) {
      TextPainter(
        text: TextSpan(text: tickLabels[0].toString(), style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(centerX, centerY - ticksTextStyle.fontSize!));
    }

    tickLabels
        .sublist(reverseAxis ? 1 : 0, reverseAxis ? ticks.length : ticks.length - 1)
        .asMap()
        .forEach((index, tick) {
      final tickRadius = tickDistance * (index + 1);

      canvas.drawPath(variablePath(size, tickRadius, sides), ticksPaint);

      TextPainter(
        text: TextSpan(text: tick.toString(), style: ticksTextStyle),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width)
        ..paint(canvas, Offset(centerX, centerY - tickRadius - ticksTextStyle.fontSize!));
    });

    final angle = (2 * pi) / features.length;

    // Print the labels
    features.asMap().forEach(
      (index, feature) {
        final xAngle = double.parse(cos(angle * index - pi / 2).toStringAsFixed(2));
        final yAngle = double.parse(sin(angle * index - pi / 2).toStringAsFixed(2));

        final labelOffset = Offset(
          xAngle < 0
              ? -labelSpacing
              : xAngle > 0
                  ? labelSpacing
                  : 0.0,
          yAngle < 0
              ? -labelSpacing
              : yAngle > 0
                  ? labelSpacing
                  : 0.0,
        );

        final featureOffset = Offset(
          centerX + radius * xAngle,
          centerY + radius * yAngle,
        );

        canvas.drawLine(centerOffset, featureOffset, ticksPaint);

        final featureLabelFontHeight = featuresTextStyle.fontSize;
        final labelYOffset = (yAngle <= 0 ? -featureLabelFontHeight! : 0) + labelOffset.dy;
        final labelXOffset = (xAngle >= 0 ? featureOffset.dx : 0.0) + labelOffset.dx;

        TextPainter(
          text: TextSpan(
            text: feature,
            style: featuresTextStyle,
          ),
          textAlign: xAngle < 0 ? TextAlign.right : TextAlign.left,
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: featureOffset.dx)
          ..paint(
            canvas,
            Offset(
              labelXOffset,
              featureOffset.dy + labelYOffset,
            ),
          );
      },
    );

    // print the polygon
    data.asMap().forEach((index, graph) {
      final graphPaint = Paint()
        ..color = graphColors[index % graphColors.length].withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final graphOutlinePaint = Paint()
        ..color = graphColors[index % graphColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      final scaledPoint = scale * graph[0] * fraction;
      final path = Path();

      if (reverseAxis) {
        path.moveTo(centerX, centerY - (radius * fraction - scaledPoint));
      } else {
        path.moveTo(centerX, centerY - scaledPoint);
      }

      graph.asMap().forEach((index, point) {
        if (index == 0) return;

        final xAngle = cos(angle * index - pi / 2);
        final yAngle = sin(angle * index - pi / 2);
        final scaledPoint = scale * point * fraction;

        if (reverseAxis) {
          path.lineTo(
            centerX + (radius * fraction - scaledPoint) * xAngle,
            centerY + (radius * fraction - scaledPoint) * yAngle,
          );
        } else {
          path.lineTo(centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        }
      });

      path.close();
      canvas.drawPath(path, graphPaint);
      canvas.drawPath(path, graphOutlinePaint);
    });
  }

  @override
  bool shouldRepaint(_RadarChartPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
