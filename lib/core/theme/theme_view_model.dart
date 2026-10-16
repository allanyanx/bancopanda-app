import 'package:flutter/material.dart';

import '../storage/key_value_storage.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel(this._storage);

  static const _key = 'modo_oscuro';

  final KeyValueStorage _storage;
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> cargar() async {
    final guardado = await _storage.read(_key);
    if (guardado == null) return;
    _mode = guardado == 'true' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    _mode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _storage.write(_key, enabled.toString());
  }
}
