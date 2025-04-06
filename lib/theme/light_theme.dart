import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color(0xFF20194C),
  brightness: Brightness.light,
  focusColor: Color(0xFFADC4C8),
  hintColor: Color(0xFF52575C),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFF0F0F0)),
);