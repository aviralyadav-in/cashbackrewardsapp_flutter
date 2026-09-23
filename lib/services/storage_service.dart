import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  static const String _themeKey = 'is_dark_mode';
  static const String _onboardingKey = 'has_seen_onboarding';

  static const String _userProfileKey = 'user_profile_data';
  static const String _userIdKey = 'user_unique_id';

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

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

  Future<void> saveUserProfileCache(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, jsonString);
  }

  Future<String?> getUserProfileCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProfileKey);
  }

  Future<void> clearUserProfileCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
  }
}
