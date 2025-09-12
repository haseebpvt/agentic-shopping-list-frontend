import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors - White theme
  static const Color primaryColor = Color(0xFF2196F3); // Blue (keeping accent)
  static const Color primaryVariant = Color(0xFF1976D2); // Darker blue
  static const Color secondary = Color(0xFFFF9800); // Orange (keeping accent)
  static const Color secondaryVariant = Color(0xFFF57C00); // Darker orange
  static const Color surface = Colors.white; // White surface
  static const Color background = Colors.white; // White background
  static const Color error = Color(0xFFD32F2F); // Error red
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onSurface = Colors.black87;
  static const Color onBackground = Colors.black87;
  static const Color onError = Colors.white;

  // Additional colors for the shopping app
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color hintColor = Color(0xFF757575);
  static const Color disabledColor = Color(0xFFBDBDBD);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: cardColor,
      dividerColor: dividerColor,
      hintColor: hintColor,
      disabledColor: disabledColor,
      
      // ColorScheme for Material 3
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryVariant,
        secondary: secondary,
        secondaryContainer: secondaryVariant,
        surface: surface,
        background: background,
        error: error,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
        onBackground: onBackground,
        onError: onError,
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: onSurface,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(color: onSurface),
        actionsIconTheme: IconThemeData(color: onSurface),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        elevation: 6,
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: const TextStyle(color: hintColor),
        labelStyle: const TextStyle(color: hintColor),
      ),

      // ListTile theme
      listTileTheme: const ListTileThemeData(
        tileColor: cardColor,
        textColor: onSurface,
        iconColor: hintColor,
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return successColor;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(onPrimary),
        side: const BorderSide(color: hintColor),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: hintColor,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: onBackground, fontWeight: FontWeight.w300),
        displayMedium: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: onBackground, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: onBackground, fontWeight: FontWeight.w500),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: hintColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: const TextStyle(
          color: onSurface,
          fontSize: 16,
        ),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800],
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: primaryColor,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
    );
  }
}
