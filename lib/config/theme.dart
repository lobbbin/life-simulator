import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryLight = Color(0xFF1565C0);
  static const Color _primaryDark = Color(0xFF90CAF9);
  static const Color _accent = Color(0xFF26A69A);
  static const Color _error = Color(0xFFD32F2F);
  static const Color _success = Color(0xFF388E3C);
  static const Color _warning = Color(0xFFF57C00);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _primaryLight,
        secondary: _accent,
        error: _error,
        surface: Colors.grey[50]!,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 0.5),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: _primaryLight,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primaryDark,
        secondary: _accent,
        error: _error,
        surface: const Color(0xFF1E1E1E),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: const Color(0xFF2C2C2C),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
      ),
      dividerTheme: DividerThemeData(space: 1, thickness: 0.5, color: Colors.grey[800]),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: _primaryDark,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Custom colors
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color energyYellow = Color(0xFFFFC107);
  static const Color happinessOrange = Color(0xFFFF9800);
  static const Color moneyGreen = Color(0xFF2E7D32);
  static const Color intelligencePurple = Color(0xFF9C27B0);
  static const Color socialBlue = Color(0xFF2196F3);
  static const Color fitnessRed = Color(0xFFF44336);
  static const Color careerTeal = Color(0xFF009688);

  static const Map<String, Color> statColors = {
    'health': healthGreen,
    'energy': energyYellow,
    'happiness': happinessOrange,
    'money': moneyGreen,
    'intelligence': intelligencePurple,
    'social': socialBlue,
    'fitness': fitnessRed,
    'career': careerTeal,
    'hunger': Color(0xFF795548),
    'stress': Color(0xFFE91E63),
    'reputation': Color(0xFF607D8B),
  };

  static Color getStatColor(String statName) {
    return statColors[statName.toLowerCase()] ?? Colors.grey;
  }

  // Reputation colors
  static const Color crimeRed = Color(0xFFB71C1C);
  static const Color politicsGold = Color(0xFFFFD700);
  static const Color businessBlue = Color(0xFF1976D2);
  static const Color tycoonGreen = Color(0xFF1B5E20);
  static const Color moviePurple = Color(0xFF6A1B9A);
  static const Color prisonGrey = Color(0xFF424242);

  static const Map<String, Color> pathColors = {
    'crime': crimeRed,
    'politics': politicsGold,
    'business': businessBlue,
    'tycoon': tycoonGreen,
    'movie': moviePurple,
    'prison': prisonGrey,
  };

  static Color getPathColor(String pathType) {
    return pathColors[pathType.toLowerCase()] ?? Colors.grey;
  }
}
