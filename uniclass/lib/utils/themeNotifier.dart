import 'package:flutter/material.dart';
import 'package:uniclass/theme/theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDark;

  ThemeNotifier(this._isDark) : _currentTheme = _isDark ? darkMode : lightMode;

  ThemeData get theme => _currentTheme;

  Future<void> changeTheme() async {
    _isDark = !_isDark;
    
    _currentTheme = _isDark ? darkMode : lightMode;
    notifyListeners();
  }
}
