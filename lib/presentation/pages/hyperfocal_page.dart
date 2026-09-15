import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/optics_repository.dart';
import '../kelvara_palette.dart';

class HyperfocalPage extends StatelessWidget {
  const HyperfocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<OpticsRepository>();
    final dof = repo.dof;

    return Scaffold(
      appBar: AppBar(title: const Text('Hyperfocal Distance')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: KelvaraPalette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: KelvaraPalette.edge),
          ),
          child: Column(
            children: [
              const Text('Hyperfocal Setting', style: TextStyle(color: KelvaraPalette.inkMuted, fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                '${dof.hyperfocalMeters.toStringAsFixed(2)} m',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: KelvaraPalette.accent),
              ),
              const SizedBox(height: 12),
              const Text(
                'Focusing at this exact distance renders everything from half the hyperfocal distance (H/2) to infinity critically sharp for landscape panoramas.',
                style: TextStyle(fontSize: 13, color: KelvaraPalette.inkMuted, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
