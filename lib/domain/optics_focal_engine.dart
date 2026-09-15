import 'dart:math';

class DofResult {
  final double hyperfocalMeters;
  final double nearLimitMeters;
  final double farLimitMeters;
  final double totalDofMeters;

  DofResult({
    required this.hyperfocalMeters,
    required this.nearLimitMeters,
    required this.farLimitMeters,
    required this.totalDofMeters,
  });
}

class OpticsFocalEngine {
  static double calculateFov(double sensorWidthMm, double focalLengthMm) {
    return 2 * atan(sensorWidthMm / (2 * focalLengthMm)) * (180 / pi);
  }

  static DofResult calculateDof({
    required double focalLengthMm,
    required double aperture,
    required double distanceMeters,
    double cocMm = 0.029, // 35mm full frame circle of confusion
  }) {
    final H = (focalLengthMm * focalLengthMm) / (aperture * cocMm * 1000); // in meters
    final near = (H * distanceMeters) / (H + (distanceMeters - (focalLengthMm / 1000)));
    final far = (H * distanceMeters) / (H - (distanceMeters - (focalLengthMm / 1000)));

    return DofResult(
      hyperfocalMeters: H,
      nearLimitMeters: near,
      farLimitMeters: far > 0 ? far : double.infinity,
      totalDofMeters: far > 0 ? (far - near) : double.infinity,
    );
  }
}
