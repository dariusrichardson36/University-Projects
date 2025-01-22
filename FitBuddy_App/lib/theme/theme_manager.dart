import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{

  static ThemeMode _themeMode = ThemeMode.light;

  static get themeMode => _themeMode;

  toggleTheme() {
    _themeMode = _themeMode==ThemeMode.light?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}