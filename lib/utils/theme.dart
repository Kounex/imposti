import 'package:flutter/material.dart';

@immutable
class ImpostiColors extends ThemeExtension<ImpostiColors> {
  final Color gradientMainSurface;
  final Color gradientSecondarySurface;

  final Color gradientMainCard;
  final Color gradientSecondaryCard;

  const ImpostiColors({
    required this.gradientMainSurface,
    required this.gradientSecondarySurface,
    required this.gradientMainCard,
    required this.gradientSecondaryCard,
  });

  @override
  ImpostiColors copyWith({
    Color? gradientMainSurface,
    Color? gradientSecondarySurface,
    Color? gradientMainCard,
    Color? gradientSecondaryCard,
  }) {
    return ImpostiColors(
      gradientMainSurface: gradientMainSurface ?? this.gradientMainSurface,
      gradientSecondarySurface:
          gradientSecondarySurface ?? this.gradientSecondarySurface,
      gradientMainCard: gradientMainCard ?? this.gradientMainCard,
      gradientSecondaryCard:
          gradientSecondaryCard ?? this.gradientSecondaryCard,
    );
  }

  @override
  ImpostiColors lerp(ImpostiColors? other, double t) {
    if (other is! ImpostiColors) {
      return this;
    }
    return ImpostiColors(
      gradientMainSurface:
          Color.lerp(gradientMainSurface, other.gradientMainSurface, t)!,
      gradientSecondarySurface:
          Color.lerp(
            gradientSecondarySurface,
            other.gradientSecondarySurface,
            t,
          )!,
      gradientMainCard:
          Color.lerp(gradientMainCard, other.gradientMainCard, t)!,
      gradientSecondaryCard:
          Color.lerp(gradientSecondaryCard, other.gradientSecondaryCard, t)!,
    );
  }
}

class ThemeUtils {
  static final ThemeData impostiLightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE69131), // Brand orange
      onPrimary: Colors.white,
      secondary: Color(0xFF406459), // Brand green
      onSecondary: Colors.white,
      surface: Color(0xFFFFF4E9), // Soft orange-tinted surface
      onSurface: Color(0xFF1B1B1B),
      error: Color(0xFFDC3545),
      onError: Colors.white,
    ),

    extensions: [
      ImpostiColors(
        gradientMainSurface: Color(0xFFE69131),
        gradientSecondarySurface: Color(0xFF406459),
        gradientMainCard: Color(0xFFE69131),
        gradientSecondaryCard: Color(0xFF406459),
      ),
    ],

    scaffoldBackgroundColor: const Color(0xFF406459),

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B1B1B),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1B1B1B)),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF406459),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFF4E9),
      foregroundColor: Color(0xFF1B1B1B),
      elevation: 3,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B1B1B),
      ),
      iconTheme: IconThemeData(color: Color(0xFF1B1B1B)),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFFF6F1EB),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD2BFA8)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE69131),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFD2BFA8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFE69131), width: 2),
      ),
      filled: true,
      fillColor: Color(0xFFF9F2E7), // Warm input fill
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFFF6F1EB),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFD2BFA8)),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B1B1B),
      ),
      contentTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF1B1B1B)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFFF7E9D9), // More orange-tinted than cards
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: Color(0xFFF7E9D9),
      showDragHandle: true,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFFE69131),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFFF6F1EB),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD2BFA8)),
      ),
      textStyle: const TextStyle(color: Color(0xFF1B1B1B), fontSize: 14),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFE69131),
      unselectedItemColor: Color(0xFFCCCCCC),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xFFE69131),
      unselectedLabelColor: Color(0xFF406459),
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFFE69131), width: 3),
      ),
    ),
  );

  static final ThemeData impostiDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE69131),
      onPrimary: Colors.black,
      secondary: Color(0xFF406459),
      onSecondary: Colors.white,
      surface: Color(0xFF2A2A2D),
      onSurface: Color(0xFFF1F1F1),
      error: Color(0xFFDC3545),
      onError: Colors.white,
    ),

    extensions: [
      ImpostiColors(
        gradientMainSurface: Color(0xFFE69131),
        gradientSecondarySurface: Color(0xFF406459),
        gradientMainCard: Color(0xFFE69131),
        gradientSecondaryCard: Color(0xFF406459),
      ),
    ],

    scaffoldBackgroundColor: const Color(0xFF000000),

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F1F1),
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFF1F1F1)),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFFE69131),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2A2A2D),
      foregroundColor: Color(0xFFF1F1F1),
      elevation: 3,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF1F1F1),
      ),
      iconTheme: IconThemeData(color: Color(0xFFF1F1F1)),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF2F2F31),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD2BFA8)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE69131),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.4),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF3F3F41)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFE69131), width: 2),
      ),
      filled: true,
      fillColor: Color(0xFF2A2A2D),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF2A2A2D),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF3F3F41)),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF1F1F1),
      ),
      contentTextStyle: const TextStyle(fontSize: 16, color: Color(0xFFF1F1F1)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF242426),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      modalBackgroundColor: Color(0xFF242426),
      showDragHandle: true,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFFE69131),
      contentTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF2A2A2D),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF3F3F41)),
      ),
      textStyle: const TextStyle(color: Color(0xFFF1F1F1), fontSize: 14),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFFE69131),
      unselectedItemColor: Color(0xFFCCCCCC),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: Color(0xFFE69131),
      unselectedLabelColor: Color(0xFFCCCCCC),
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xFFE69131), width: 3),
      ),
    ),
  );
}
