import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/optics_repository.dart';
import '../kelvara_palette.dart';

class SensorDatabasePage extends StatelessWidget {
  const SensorDatabasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<OpticsRepository>();
    final sensors = [
      {'name': 'Full Frame 35mm (1.0x)', 'w': 36.0},
      {'name': 'APS-C Crop (1.5x)', 'w': 23.6},
      {'name': 'Canon APS-C (1.6x)', 'w': 22.3},
      {'name': 'Micro Four Thirds (2.0x)', 'w': 17.3},
      {'name': '1-Inch Compact (2.7x)', 'w': 13.2},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Profiles')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sensors.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, idx) {
          final s = sensors[idx];
          final isSel = repo.sensorWidthMm == s['w'];
          return ListTile(
            tileColor: KelvaraPalette.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSel ? KelvaraPalette.accent : KelvaraPalette.edge),
            ),
            title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: isSel ? const Icon(Icons.check_circle, color: KelvaraPalette.accent) : null,
            onTap: () => repo.updateParams(sensor: s['w'] as double),
          );
        },
      ),
    );
  }
}
