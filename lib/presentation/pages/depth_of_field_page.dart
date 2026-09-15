import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/optics_repository.dart';
import '../kelvara_palette.dart';

class DepthOfFieldPage extends StatelessWidget {
  const DepthOfFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<OpticsRepository>();
    final dof = repo.dof;

    return Scaffold(
      appBar: AppBar(title: const Text('Depth of Field Plane')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: KelvaraPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KelvaraPalette.edge),
              ),
              child: Column(
                children: [
                  _row('Near Focus Limit', '${dof.nearLimitMeters.toStringAsFixed(2)} m'),
                  const Divider(color: KelvaraPalette.edge),
                  _row('Subject Plane', '${repo.subjectDistanceMeters.toStringAsFixed(2)} m'),
                  const Divider(color: KelvaraPalette.edge),
                  _row('Far Focus Limit', dof.farLimitMeters.isInfinite ? 'Infinity (∞)' : '${dof.farLimitMeters.toStringAsFixed(2)} m'),
                  const Divider(color: KelvaraPalette.edge),
                  _row('Total Sharp Depth', dof.totalDofMeters.isInfinite ? 'Infinite' : '${dof.totalDofMeters.toStringAsFixed(2)} m'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
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
                      const Text('Subject Distance', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${repo.subjectDistanceMeters.toStringAsFixed(1)} m', style: const TextStyle(fontWeight: FontWeight.bold, color: KelvaraPalette.accent)),
                    ],
                  ),
                  Slider(
                    value: repo.subjectDistanceMeters,
                    min: 0.5,
                    max: 15.0,
                    divisions: 29,
                    activeColor: KelvaraPalette.accent,
                    onChanged: (v) => repo.updateParams(dist: v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: KelvaraPalette.inkMuted)),
          Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: KelvaraPalette.ink)),
        ],
      ),
    );
  }
}
