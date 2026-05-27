import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../storage/shared_prefs_service.dart';
import '../constants/app_constants.dart';

/// Manages theme mode with SharedPreferences persistence.
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPrefsService _prefsService;

  ThemeCubit(this._prefsService) : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final saved = _prefsService.getThemeMode();
    if (saved == null) return;
    switch (saved) {
      case 'light':
        emit(ThemeMode.light);
      case 'dark':
        emit(ThemeMode.dark);
      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setLight() async {
    await _prefsService.saveThemeMode('light');
    emit(ThemeMode.light);
  }

  Future<void> setDark() async {
    await _prefsService.saveThemeMode('dark');
    emit(ThemeMode.dark);
  }

  Future<void> setSystem() async {
    await _prefsService.saveThemeMode(AppConstants.themeModeKey);
    emit(ThemeMode.system);
  }

  Future<void> toggle() async {
    if (state == ThemeMode.dark) {
      await setLight();
    } else {
      await setDark();
    }
  }
}
