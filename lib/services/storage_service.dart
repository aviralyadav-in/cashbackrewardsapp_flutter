import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  static const String _themeKey = 'is_dark_mode';
  static const String _onboardingKey = 'has_seen_onboarding';

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> saveHasSeenOnboarding(bool hasSeen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, hasSeen);
  }
}
