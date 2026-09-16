import 'dart:math';
import 'package:flutter/material.dart';
import 'theme/kelvara_theme.dart';
import 'painters/focal_plane_frustum_painter.dart';

class KelvaraApp extends StatefulWidget {
  const KelvaraApp({super.key});

  @override
  State<KelvaraApp> createState() => _KelvaraAppState();
}

class _KelvaraAppState extends State<KelvaraApp> {
  double _focalLengthMm = 35.0;
  String _sensorFormat = 'Full Frame (36x24mm)';
  double _aperture = 2.8;
  double _distanceMeters = 3.0;

  double get _sensorWidthMm {
    if (_sensorFormat.startsWith('APS-C')) return 23.5;
    if (_sensorFormat.startsWith('Micro')) return 17.3;
    return 36.0; // Full Frame
  }

  double get _fovDegrees {
    final rad = 2 * atan(_sensorWidthMm / (2 * _focalLengthMm));
    return rad * (180 / pi);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelvara Optics',
      debugShowCheckedModeBanner: false,
      theme: KelvaraTheme.themeData,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('KELVARA LENS METER',
                style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold, fontSize: 16)),
            bottom: const TabBar(
              labelColor: KelvaraTheme.accent,
              unselectedLabelColor: KelvaraTheme.muted,
              indicatorColor: KelvaraTheme.accent,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.videocam_outlined), text: 'FOV Angle'),
                Tab(icon: Icon(Icons.blur_on), text: 'Depth of Field'),
                Tab(icon: Icon(Icons.landscape_outlined), text: 'Hyperfocal'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildFovTab(),
              _buildDofTab(),
              _buildHyperfocalTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFovTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic Frustum Display
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KelvaraTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KelvaraTheme.edge),
            ),
            child: CustomPaint(
              painter: FocalPlaneFrustumPainter(
                focalLengthMm: _focalLengthMm,
                fovDegrees: _fovDegrees,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Angle Readout Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KelvaraTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: KelvaraTheme.edge),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Horizontal Field of View', style: TextStyle(color: KelvaraTheme.muted, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('${_fovDegrees.toStringAsFixed(1)}°',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: KelvaraTheme.accent)),
                  ],
                ),
                Text('Focal: ${_focalLengthMm.round()}mm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Focal Length Slider
          const Text('Focal Length (mm)', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _focalLengthMm,
            min: 14.0,
            max: 200.0,
            divisions: 186,
            activeColor: KelvaraTheme.accent,
            onChanged: (v) => setState(() => _focalLengthMm = v),
          ),
          // Preset Quick Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [24, 35, 50, 85, 135].map((fl) {
              final isSel = _focalLengthMm.round() == fl;
              return ChoiceChip(
                label: Text('${fl}mm'),
                selected: isSel,
                selectedColor: KelvaraTheme.accent,
                labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                onSelected: (_) => setState(() => _focalLengthMm = fl.toDouble()),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Sensor Format Picker
          const Text('Sensor Format', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _sensorFormat,
            decoration: InputDecoration(
              filled: true,
              fillColor: KelvaraTheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: const [
              DropdownMenuItem(value: 'Full Frame (36x24mm)', child: Text('Full Frame (36x24mm)')),
              DropdownMenuItem(value: 'APS-C Crop 1.5x (23.5x15.6mm)', child: Text('APS-C Crop 1.5x (23.5x15.6mm)')),
              DropdownMenuItem(value: 'Micro 4/3 Crop 2.0x (17.3x13mm)', child: Text('Micro 4/3 Crop 2.0x (17.3x13mm)')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _sensorFormat = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDofTab() {
    // Circle of confusion for 35mm full frame ~ 0.03mm
    const coc = 0.03;
    final hMm = (_focalLengthMm * _focalLengthMm) / (_aperture * coc);
    final sMm = _distanceMeters * 1000;
    final nearMm = (hMm * sMm) / (hMm + sMm);
    final farMm = (hMm * sMm) / (hMm - sMm);

    final nearM = (nearMm / 1000).clamp(0.1, 100.0).toStringAsFixed(2);
    final farM = farMm <= 0 ? 'Infinity' : '${(farMm / 1000).toStringAsFixed(2)} m';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Depth of Field Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KelvaraTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: KelvaraTheme.edge),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Near Sharp Focus Limit:'),
                    Text('$nearM m', style: const TextStyle(fontWeight: FontWeight.bold, color: KelvaraTheme.accent)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Far Sharp Focus Limit:'),
                    Text(farM, style: const TextStyle(fontWeight: FontWeight.bold, color: KelvaraTheme.accent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Aperture: f/$_aperture', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _aperture,
            min: 1.4,
            max: 16.0,
            activeColor: KelvaraTheme.accent,
            onChanged: (v) => setState(() => _aperture = (v * 10).round() / 10),
          ),
          const SizedBox(height: 12),
          Text('Subject Distance: ${_distanceMeters.toStringAsFixed(1)} m', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _distanceMeters,
            min: 0.5,
            max: 15.0,
            activeColor: KelvaraTheme.accent,
            onChanged: (v) => setState(() => _distanceMeters = v),
          ),
        ],
      ),
    );
  }

  Widget _buildHyperfocalTab() {
    const coc = 0.03;
    final hM = ((_focalLengthMm * _focalLengthMm) / (_aperture * coc)) / 1000;

    final table = [
      {'fl': '24mm', 'f28': '6.8 m', 'f8': '2.4 m', 'f11': '1.7 m'},
      {'fl': '35mm', 'f28': '14.6 m', 'f8': '5.1 m', 'f11': '3.7 m'},
      {'fl': '50mm', 'f28': '29.8 m', 'f8': '10.4 m', 'f11': '7.6 m'},
      {'fl': '85mm', 'f28': '86.0 m', 'f8': '30.1 m', 'f11': '21.9 m'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KelvaraTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KelvaraTheme.edge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Setup Hyperfocal Point', style: TextStyle(color: KelvaraTheme.muted, fontSize: 12)),
              const SizedBox(height: 4),
              Text('${hM.toStringAsFixed(1)} Meters',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: KelvaraTheme.accent)),
              const SizedBox(height: 6),
              const Text('Focusing at this distance renders everything from half this distance to infinity sharply in focus.',
                  style: TextStyle(fontSize: 12, color: KelvaraTheme.muted)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Standard Landscape Hyperfocal Table', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...table.map((row) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KelvaraTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: KelvaraTheme.edge),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row['fl']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('f/2.8: ${row['f28']}', style: const TextStyle(fontSize: 12)),
                  Text('f/8: ${row['f8']}', style: const TextStyle(fontSize: 12, color: KelvaraTheme.accent, fontWeight: FontWeight.bold)),
                  Text('f/11: ${row['f11']}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            )),
      ],
    );
  }
}
