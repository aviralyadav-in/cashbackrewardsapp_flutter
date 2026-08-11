import 'package:shared_preferences/shared_preferences.dart';

class AppStorageService {
  static const String _defaultFavoriteKey = 'favorite_product_ids_guest';
  static const String _themeKey = 'is_dark_mode';

  String _getFavoriteKey(String? userId) {
    if (userId != null && userId.isNotEmpty) {
      return 'favorite_product_ids_$userId';
    }
    return _defaultFavoriteKey;
  }

  Future<List<int>> getFavoriteProductIds([String? userId]) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoriteKey(userId);
    final values = prefs.getStringList(key) ?? <String>[];

    return values
        .map((value) {
          final parsed = int.tryParse(value);
          return parsed;
        })
        .whereType<int>()
        .toList();
  }

  Future<void> saveFavoriteProductIds(Set<int> ids, [String? userId]) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getFavoriteKey(userId);
    await prefs.setStringList(
      key,
      ids.map((id) => id.toString()).toList(),
    );
  }

  Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  static const String _onboardingKey = 'has_seen_onboarding';

  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> saveHasSeenOnboarding(bool hasSeen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, hasSeen);
  }
}
