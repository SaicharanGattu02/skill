import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  AppThemeMode _appThemeMode;
  Brightness _systemBrightness = Brightness.light;

  ThemeProvider(this._appThemeMode) {
    WidgetsBinding.instance.addObserver(this);
    _updateSystemBrightness();
  }

  AppThemeMode get appThemeMode => _appThemeMode;

  /// Get the current theme data based on the selected mode
  ThemeData get themeData {
    switch (_appThemeMode) {
      case AppThemeMode.dark:
        return darkTheme;
      case AppThemeMode.light:
        return lightTheme;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  /// Dynamic text color based on theme
  Color get textColor {
    switch (_appThemeMode) {
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.light:
        return Colors.black;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    }
  }

  Color get curserColor{
    switch(_appThemeMode){
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.light:
        return Colors.black;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    }
  }

  Color get containerbcColor{
    switch (_appThemeMode){
      case AppThemeMode.dark:
        return Color(0xff1F2226);
      case  AppThemeMode.light:
        return Colors.white;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Color(0xff1F2226):Colors.white;


    }
  }

  Color get decorationColor{
    switch(_appThemeMode){
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.light:
        return Colors.black;
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    }
  }
  Color get fillColor{
    switch(_appThemeMode){
      case AppThemeMode.dark:
        return Colors.white12;
      case AppThemeMode.light:
        return Color(0xffFCFAFF);
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white12
            : Color(0xffFCFAFF);
    }
  }
  Color get containerBorder{
    switch(_appThemeMode){
      case AppThemeMode.dark:
        return  Colors.white12;
      case AppThemeMode.light:
        return Color(0xff8856F4);
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white12
            : Color(0xff8856F4);
    }
  }


  Color get primaryText{
    switch(_appThemeMode){
      case AppThemeMode.dark:
        return  Colors.white12;
      case AppThemeMode.light:
        return Color(0xff8856F4);
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? Colors.white12
            : Color(0xff8856F4);
    }
  }

  /// Dynamic container color based on theme
  Color get containerColor {
    switch (_appThemeMode) {
      case AppThemeMode.dark:
        return const Color(0xff212121); // Dark gray for dark theme
      case AppThemeMode.light:
        return Colors.white; // White for light theme
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? const Color(0xff212121) // Dark gray for dark theme
            : Colors.white; // White for light theme
    }
  }

  /// Dynamic scaffold background color
  Color get scaffoldBackgroundColor {
    switch (_appThemeMode) {
      case AppThemeMode.dark:
        return const Color(0xff181818); // Dark theme background
      case AppThemeMode.light:
        return const Color(0xffF5F5F5); // Light theme background
      case AppThemeMode.system:
        return _systemBrightness == Brightness.dark
            ? const Color(0xff181818) // Dark theme background
            : const Color(0xffF5F5F5); // Light theme background
    }
  }

  /// Update the theme mode and notify listeners
  void setThemeMode(AppThemeMode mode) {
    _appThemeMode = mode;
    notifyListeners();
  }

  /// Toggle between light and dark themes
  void toggleTheme() {
    if (_appThemeMode == AppThemeMode.dark) {
      _appThemeMode = AppThemeMode.light;
    } else {
      _appThemeMode = AppThemeMode.dark;
    }
    notifyListeners();
  }

  /// Update system brightness when the platform brightness changes
  void _updateSystemBrightness() {
    _systemBrightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;
    if (_appThemeMode == AppThemeMode.system) {
      notifyListeners(); // Notify listeners to reflect the new system theme
    }
  }

  /// Called when the platform brightness changes
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateSystemBrightness();
  }

  /// Remove observer when the provider is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


}
