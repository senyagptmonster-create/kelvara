import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/optics_repository.dart';
import '../kelvara_palette.dart';

class FovMeterPage extends StatelessWidget {
  const FovMeterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<OpticsRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Field-of-View Meter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: KelvaraPalette.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KelvaraPalette.edge),
              ),
              child: Column(
                children: [
                  Text(
                    '${repo.fovDegrees.toStringAsFixed(1)}°',
                    style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: KelvaraPalette.accent),
                  ),
                  const SizedBox(height: 4),
                  const Text('Horizontal Diagonal Angle', style: TextStyle(color: KelvaraPalette.inkMuted, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: KelvaraPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KelvaraPalette.edge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Focal Length', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${repo.focalLengthMm.toInt()} mm', style: const TextStyle(fontWeight: FontWeight.bold, color: KelvaraPalette.accent)),
                    ],
                  ),
                  Slider(
                    value: repo.focalLengthMm,
                    min: 14.0,
                    max: 200.0,
                    divisions: 37,
                    activeColor: KelvaraPalette.accent,
                    onChanged: (v) => repo.updateParams(focal: v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Aperture (f-stop)', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('f/${repo.aperture.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, color: KelvaraPalette.accent)),
                    ],
                  ),
                  Slider(
                    value: repo.aperture,
                    min: 1.2,
                    max: 16.0,
                    divisions: 15,
                    activeColor: KelvaraPalette.accent,
                    onChanged: (v) => repo.updateParams(ap: v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
