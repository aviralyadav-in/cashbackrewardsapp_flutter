import 'package:flutter/foundation.dart';

import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final AppStorageService _storageService;

  bool isDarkMode = false;

  ThemeProvider({AppStorageService? storageService})
    : _storageService = storageService ?? AppStorageService();

  Future<void> initialize() async {
    isDarkMode = await _storageService.getThemePreference();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    await _storageService.saveThemePreference(isDarkMode);
    notifyListeners();
  }
}
