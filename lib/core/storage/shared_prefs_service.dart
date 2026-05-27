import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Wrapper around SharedPreferences for lightweight key-value storage.
/// Only used for theme mode and small flags — never for objects.
class SharedPrefsService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  // ── Theme ──────────────────────────────────────────────────────────────────

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.themeModeKey, mode);
  }

  String? getThemeMode() => _prefs.getString(AppConstants.themeModeKey);

  // ── Onboarding ─────────────────────────────────────────────────────────────

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(AppConstants.onboardingCompleteKey, true);
  }

  bool isOnboardingComplete() =>
      _prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
}
