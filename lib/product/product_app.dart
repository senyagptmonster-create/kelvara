import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/brand.dart';
import 'screens.dart';
import 'kelvara_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KelvaraStore()..load(),
      child: MaterialApp(
        title: 'Kelvara',
        theme: ThemeData(
          primaryColor: cAccent,
          scaffoldBackgroundColor: cBg,
        ),
        home: const KelvaraHome(),
      ),
    );
  }
}

class KelvaraHome extends StatefulWidget {
  const KelvaraHome({super.key});
  @override
  State<KelvaraHome> createState() => _KelvaraHomeState();
}

class _KelvaraHomeState extends State<KelvaraHome> {
  int _idx = 0;
  final _tabs = [const FovScreen(), const DofScreen(), const HyperfocalScreen(), const SensorScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      body: _tabs[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        backgroundColor: cSurface,
        selectedItemColor: cAccent,
        unselectedItemColor: cEdge,
        onTap: (i) {
          setState(() { _idx = i; });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'FOV'),
          BottomNavigationBarItem(icon: Icon(Icons.blur_on), label: 'DOF'),
          BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Hyperfocal'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Sensors'),
        ],
      ),
    );
  }
}
