import 'package:flutter/material.dart';
import '../domain/optics_focal_engine.dart';

class OpticsRepository extends ChangeNotifier {
  double _focalLengthMm = 50.0;
  double _aperture = 2.8;
  double _subjectDistanceMeters = 2.5;
  double _sensorWidthMm = 36.0; // Full frame

  double get focalLengthMm => _focalLengthMm;
  double get aperture => _aperture;
  double get subjectDistanceMeters => _subjectDistanceMeters;
  double get sensorWidthMm => _sensorWidthMm;

  double get fovDegrees => OpticsFocalEngine.calculateFov(_sensorWidthMm, _focalLengthMm);
  DofResult get dof => OpticsFocalEngine.calculateDof(
    focalLengthMm: _focalLengthMm,
    aperture: _aperture,
    distanceMeters: _subjectDistanceMeters,
  );

  void updateParams({double? focal, double? ap, double? dist, double? sensor}) {
    if (focal != null) _focalLengthMm = focal;
    if (ap != null) _aperture = ap;
    if (dist != null) _subjectDistanceMeters = dist;
    if (sensor != null) _sensorWidthMm = sensor;
    notifyListeners();
  }
}
