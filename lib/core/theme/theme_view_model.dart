import 'package:flutter/material.dart';

/// Controla si la app está en modo claro u oscuro.
class ThemeViewModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    _mode = enabled ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Avisa a las vistas que deben redibujarse
  }
}