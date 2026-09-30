import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist and manage recent search queries locally
class RecentSearchService {
  static const String _recentSearchesKey = 'kashiq_recent_searches_list';
  static const int _maxRecentSearches = 10;

  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentSearchesKey) ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> current = prefs.getStringList(_recentSearchesKey) ?? [];

      // Remove existing case-insensitively
      current.removeWhere((item) => item.toLowerCase() == trimmed.toLowerCase());
      current.insert(0, trimmed);

      if (current.length > _maxRecentSearches) {
        current = current.sublist(0, _maxRecentSearches);
      }

      await prefs.setStringList(_recentSearchesKey, current);
    } catch (_) {}
  }

  Future<void> removeRecentSearch(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> current = prefs.getStringList(_recentSearchesKey) ?? [];
      current.removeWhere((item) => item.toLowerCase() == query.trim().toLowerCase());
      await prefs.setStringList(_recentSearchesKey, current);
    } catch (_) {}
  }

  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchesKey);
    } catch (_) {}
  }
}
