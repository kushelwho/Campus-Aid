import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Theme mode (light/dark)
  ThemeMode _themeMode = ThemeMode.light;

  // Font size scale factor (1.0 is normal)
  double _fontSize = 1.0;

  // Theme and font size keys for shared preferences
  static const String _themeModeKey = 'theme_mode';
  static const String _fontSizeKey = 'font_size';

  // Constructor to initialize theme preferences
  ThemeProvider() {
    _loadPreferences();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;

  // Determine if current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Load saved preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode (0 = light, 1 = dark, 2 = system)
    final themeValue = prefs.getInt(_themeModeKey) ?? 0;
    _themeMode = ThemeMode.values[themeValue];

    // Load font size
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 1.0;

    // Notify listeners after loading preferences
    notifyListeners();
  }

  // Save current preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Save theme mode as integer
    await prefs.setInt(_themeModeKey, _themeMode.index);

    // Save font size
    await prefs.setDouble(_fontSizeKey, _fontSize);
  }

  // Toggle between light and dark mode
  void toggleThemeMode() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _savePreferences();
    notifyListeners();
  }

  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _savePreferences();
    notifyListeners();
  }

  // Update font size
  void setFontSize(double size) {
    // Constrain font size between 0.8 and 1.2
    _fontSize = size.clamp(0.8, 1.2);
    _savePreferences();
    notifyListeners();
  }

  // Get font size label for UI display
  String getFontSizeLabel() {
    if (_fontSize <= 0.8) {
      return 'Small';
    } else if (_fontSize <= 0.9) {
      return 'Medium Small';
    } else if (_fontSize <= 1.0) {
      return 'Medium';
    } else if (_fontSize <= 1.1) {
      return 'Medium Large';
    } else {
      return 'Large';
    }
  }

  // Get text theme with adjusted sizes
  TextTheme getAdjustedTextTheme(TextTheme baseTheme) {
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontSize:
            baseTheme.displayLarge?.fontSize != null
                ? baseTheme.displayLarge!.fontSize! * _fontSize
                : null,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontSize:
            baseTheme.displayMedium?.fontSize != null
                ? baseTheme.displayMedium!.fontSize! * _fontSize
                : null,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        fontSize:
            baseTheme.displaySmall?.fontSize != null
                ? baseTheme.displaySmall!.fontSize! * _fontSize
                : null,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        fontSize:
            baseTheme.headlineLarge?.fontSize != null
                ? baseTheme.headlineLarge!.fontSize! * _fontSize
                : null,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontSize:
            baseTheme.headlineMedium?.fontSize != null
                ? baseTheme.headlineMedium!.fontSize! * _fontSize
                : null,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        fontSize:
            baseTheme.headlineSmall?.fontSize != null
                ? baseTheme.headlineSmall!.fontSize! * _fontSize
                : null,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        fontSize:
            baseTheme.titleLarge?.fontSize != null
                ? baseTheme.titleLarge!.fontSize! * _fontSize
                : null,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontSize:
            baseTheme.titleMedium?.fontSize != null
                ? baseTheme.titleMedium!.fontSize! * _fontSize
                : null,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        fontSize:
            baseTheme.titleSmall?.fontSize != null
                ? baseTheme.titleSmall!.fontSize! * _fontSize
                : null,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize:
            baseTheme.bodyLarge?.fontSize != null
                ? baseTheme.bodyLarge!.fontSize! * _fontSize
                : null,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize:
            baseTheme.bodyMedium?.fontSize != null
                ? baseTheme.bodyMedium!.fontSize! * _fontSize
                : null,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        fontSize:
            baseTheme.bodySmall?.fontSize != null
                ? baseTheme.bodySmall!.fontSize! * _fontSize
                : null,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontSize:
            baseTheme.labelLarge?.fontSize != null
                ? baseTheme.labelLarge!.fontSize! * _fontSize
                : null,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        fontSize:
            baseTheme.labelMedium?.fontSize != null
                ? baseTheme.labelMedium!.fontSize! * _fontSize
                : null,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        fontSize:
            baseTheme.labelSmall?.fontSize != null
                ? baseTheme.labelSmall!.fontSize! * _fontSize
                : null,
      ),
    );
  }
}
