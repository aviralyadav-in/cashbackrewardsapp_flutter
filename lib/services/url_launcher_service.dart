import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Opens external website URL cleanly with validation and fallback.
  static Future<bool> openUrl(String urlString) async {
    final clean = urlString.trim();
    if (clean.isEmpty) return false;

    var formatted = clean;
    if (!formatted.startsWith('http://') && !formatted.startsWith('https://')) {
      formatted = 'https://$formatted';
    }

    final Uri? uri = Uri.tryParse(formatted);
    if (uri == null) return false;

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to platform default launch mode
        return await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      debugPrint('Error launching URL ($urlString): $e');
      return false;
    }
  }
}
