import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/optics_repository.dart';
import 'kelvara_palette.dart';
import 'pages/fov_meter_page.dart';
import 'pages/depth_of_field_page.dart';
import 'pages/hyperfocal_page.dart';
import 'pages/sensor_database_page.dart';

class KelvaraApp extends StatelessWidget {
  const KelvaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OpticsRepository(),
      child: MaterialApp(
        title: 'Kelvara Lens Meter',
        debugShowCheckedModeBanner: false,
        theme: KelvaraPalette.theme,
        home: const _KelvaraShell(),
      ),
    );
  }
}

class _KelvaraShell extends StatelessWidget {
  const _KelvaraShell();

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            FovMeterPage(),
            DepthOfFieldPage(),
            HyperfocalPage(),
            SensorDatabasePage(),
          ],
        ),
        bottomNavigationBar: Material(
          color: KelvaraPalette.surface,
          child: TabBar(
            labelColor: KelvaraPalette.accent,
            indicatorColor: KelvaraPalette.accent,
            tabs: [
              Tab(icon: Icon(Icons.crop_free), text: 'FOV'),
              Tab(icon: Icon(Icons.filter_center_focus), text: 'DOF'),
              Tab(icon: Icon(Icons.landscape_outlined), text: 'Hyperfocal'),
              Tab(icon: Icon(Icons.camera_alt_outlined), text: 'Sensors'),
            ],
          ),
        ),
      ),
    );
  }
}
