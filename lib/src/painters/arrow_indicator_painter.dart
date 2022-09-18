import 'package:flutter/material.dart';
import 'package:info_popup/src/enums/arrow_direction.dart';

/// [ArrowIndicatorPainter] is custom painter for drawing a triangle indicator for popup
/// to point specific widget
class ArrowIndicatorPainter extends CustomPainter {
  /// Creates a [ArrowIndicatorPainter]
  ArrowIndicatorPainter({
    required this.arrowDirection,
    this.arrowColor = Colors.black,
  });

  /// [arrowDirection] is the direction of the arrow
  final ArrowDirection arrowDirection;

  /// [arrowColor] is the color of the arrow
  final Color arrowColor;

  /// Draws the triangle of specific [size] on [canvas]
  @override
  void paint(Canvas canvas, Size size) {
    final Path arrowPath = Path();
    final Paint arrowPaint = Paint();
    arrowPaint.strokeWidth = 2.0;
    arrowPaint.color = arrowColor;
    arrowPaint.style = PaintingStyle.fill;

    switch (arrowDirection) {
      case ArrowDirection.up:
        arrowPath.moveTo(size.width / 2.0, 0.0);
        arrowPath.lineTo(0.0, size.height + 1);
        arrowPath.lineTo(size.width, size.height + 1);
        break;
      case ArrowDirection.down:
        arrowPath.moveTo(0.0, -1.0);
        arrowPath.lineTo(size.width, -1.0);
        arrowPath.lineTo(size.width / 2.0, size.height);
        break;
    }

    canvas.drawPath(arrowPath, arrowPaint);
  }

  /// [shouldRepaint] is called when the [CustomPainter] is asked to paint again.
  @override
  bool shouldRepaint(CustomPainter customPainter) => true;
}
