import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LocalizationProvider({required this.sharedPreferences});

  bool _isLtr = true;

  bool get isLtr => _isLtr;
}