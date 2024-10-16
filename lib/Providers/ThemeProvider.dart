import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void setLightTheme() {
    _themeData = lightTheme;
    notifyListeners();
  }

  void setDarkTheme() {
    _themeData = darkTheme;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeData = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness == Brightness.dark
        ? darkTheme
        : lightTheme;
    notifyListeners();
  }
}
