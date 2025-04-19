import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF269D9D),
  primarySwatch: MaterialColor(
    0xFF269D9D,
    <int, Color>{
      50: Color(0xFFE0F7F7),
      100: Color(0xFFB3ECEC),
      200: Color(0xFF80E0E0),
      300: Color(0xFF4DD4D4),
      400: Color(0xFF26C9C9),
      500: Color(0xFF269D9D),
      600: Color(0xFF238E8E),
      700: Color(0xFF1F7C7C),
      800: Color(0xFF1A6A6A),
      900: Color(0xFF134F4F),
    },
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.interTextTheme(),
);
