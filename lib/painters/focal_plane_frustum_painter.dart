import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/kelvara_theme.dart';

class FocalPlaneFrustumPainter extends CustomPainter {
  final double focalLengthMm;
  final double fovDegrees;

  FocalPlaneFrustumPainter({
    required this.focalLengthMm,
    required this.fovDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Camera origin at left
    final cameraOrigin = Offset(40, height / 2);

    // Sensor plane rectangle
    final sensorPaint = Paint()..color = const Color(0xFF334155);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(28, height / 2), width: 6, height: 48),
        const Radius.circular(2),
      ),
      sensorPaint,
    );

    // Lens optical center dot
    final lensPaint = Paint()..color = KelvaraTheme.accent;
    canvas.drawCircle(cameraOrigin, 5, lensPaint);

    // FOV Frustum cone
    final halfAngleRad = (fovDegrees / 2) * (pi / 180);
    final coneLength = width - 70;
    final halfSpread = coneLength * tan(halfAngleRad.clamp(0.08, 1.2));

    final frustumPath = Path()
      ..moveTo(cameraOrigin.dx, cameraOrigin.dy)
      ..lineTo(cameraOrigin.dx + coneLength, cameraOrigin.dy - halfSpread)
      ..lineTo(cameraOrigin.dx + coneLength, cameraOrigin.dy + halfSpread)
      ..close();

    final coneFill = Paint()
      ..shader = LinearGradient(
        colors: [
          KelvaraTheme.accent.withValues(alpha: 0.25),
          KelvaraTheme.accentLight.withValues(alpha: 0.05),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(cameraOrigin.dx, 0, coneLength, height));

    canvas.drawPath(frustumPath, coneFill);

    final coneStroke = Paint()
      ..color = KelvaraTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(frustumPath, coneStroke);

    // Focal plane indicator line at midpoint
    final focalX = cameraOrigin.dx + coneLength * 0.55;
    final focalSpread = (focalX - cameraOrigin.dx) * tan(halfAngleRad.clamp(0.08, 1.2));
    final focalPaint = Paint()
      ..color = Colors.amber.shade700
      ..strokeWidth = 2.5;
    canvas.drawLine(
      Offset(focalX, cameraOrigin.dy - focalSpread),
      Offset(focalX, cameraOrigin.dy + focalSpread),
      focalPaint,
    );

    // Angle label arc
    final arcRect = Rect.fromCircle(center: cameraOrigin, radius: 28);
    canvas.drawArc(arcRect, -halfAngleRad, 2 * halfAngleRad, false, coneStroke);
  }

  @override
  bool shouldRepaint(covariant FocalPlaneFrustumPainter oldDelegate) {
    return oldDelegate.focalLengthMm != focalLengthMm || oldDelegate.fovDegrees != fovDegrees;
  }
}
