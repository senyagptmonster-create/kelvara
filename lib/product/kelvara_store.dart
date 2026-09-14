import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KelvaraStore extends ChangeNotifier {
  double focalLength = 50.0;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    focalLength = prefs.getDouble('focal') ?? 50.0;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setFocalLength(double f) async {
    focalLength = f;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('focal', f);
    notifyListeners();
  }
}
