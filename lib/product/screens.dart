import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/brand.dart';
import '../app/theme.dart';
import 'kelvara_store.dart';

class FovScreen extends StatelessWidget {
  const FovScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = context.watch<KelvaraStore>();
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('FOV Angle', style: AppTheme.display(cInk)), backgroundColor: cSurface),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Focal Length: ${store.focalLength}mm', style: AppTheme.text(cInk)),
            Slider(
              value: store.focalLength,
              min: 10,
              max: 200,
              onChanged: (v) { store.setFocalLength(v); },
            ),
          ],
        ),
      ),
    );
  }
}

class DofScreen extends StatelessWidget {
  const DofScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('DOF Table', style: AppTheme.display(cInk)), backgroundColor: cSurface),
      body: Center(child: Text('Depth of Field data', style: AppTheme.text(cInk))),
    );
  }
}

class HyperfocalScreen extends StatelessWidget {
  const HyperfocalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Hyperfocal Distance', style: AppTheme.display(cInk)), backgroundColor: cSurface),
      body: Center(child: Text('Calculated HFD', style: AppTheme.text(cInk))),
    );
  }
}

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Sensor Profiles', style: AppTheme.display(cInk)), backgroundColor: cSurface),
      body: Center(child: Text('Full Frame, APS-C', style: AppTheme.text(cInk))),
    );
  }
}
