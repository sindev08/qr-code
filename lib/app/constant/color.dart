import 'package:flutter/material.dart';

class CustomColors {
  static final black = Color(0xFF000000);
  static final white = Color(0xFFFFFFFF);

  static const MaterialColor primary = MaterialColor(
    0xFF4628F1,
    <int, Color>{
      50: Color(0xFFECE9FD),
      100: Color(0xFFDAD4FC),
      200: Color(0xFFB5A9F9),
      300: Color(0xFF907EF6),
      400: Color(0xFF6A52F3),
      500: Color(0xFF4628F1),
      600: Color(0xFF3820C0),
      700: Color(0xFF2A1890),
      800: Color(0xFF1C1060),
      900: Color(0xFF0E0830),
    },
  );

  // static const MaterialColor secondary = MaterialColor(
  //   0xFF00BFFF,
  //   <int, Color>{
  //     50: Color(0xFFE6F7FF),
  //     100: Color(0xFFB2D4FF),
  //     200: Color(0xFF80B1FF),
  //     300: Color(0xFF4E8EFF),
  //     400: Color(0xFF1B6BFF),
  //     500: Color(0xFF0060FF),
  //     600: Color(0xFF0054E1),
  //     700: Color(0xFF0049BF),
  //     800: Color(0xFF003D9D),
  //     900: Color(0xFF00327B),
  //   },
  // );

  static const MaterialColor warning = MaterialColor(
    0xFFFFC107,
    <int, Color>{
      50: Color(0xFFFFF9E6),
      100: Color(0xFFFFF08F),
      200: Color(0xFFFFE93E),
      300: Color(0xFFFFE000),
      400: Color(0xFFFFD500),
      500: Color(0xFFFFC107),
      600: Color(0xFFFFB300),
      700: Color(0xFFFFA000),
      800: Color(0xFFFF9000),
      900: Color(0xFFFF8000),
    },
  );

  static const MaterialColor grey = MaterialColor(
    0xFF64748B,
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B),
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
    },
  );
}
