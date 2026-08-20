import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime config from `flutter_app/.env` (mirrors web VITE_* vars).
class AppConfig {
  /// True when a real website origin was provided. Without this, Android
  /// phones would try the emulator-only host `10.0.2.2` and show an empty
  /// WebView instead of the bundled skeleton.
  static bool get hasExplicitSiteUrl {
    const fromDefine = String.fromEnvironment('SITE_URL', defaultValue: '');
    if (fromDefine.trim().isNotEmpty) return true;
    if (!dotenv.isInitialized) return false;
    final fromEnv =
        (dotenv.env['VITE_SITE_URL'] ?? dotenv.env['SITE_URL'] ?? '').trim();
    return fromEnv.isNotEmpty;
  }

  /// Website origin that serves the `/embed/*` routes shown in WebViews.
  static String get siteBaseUrl {
    const fromDefine = String.fromEnvironment('SITE_URL', defaultValue: '');
    if (fromDefine.trim().isNotEmpty) return _withoutTrailingSlash(fromDefine);

    if (dotenv.isInitialized) {
      final fromEnv =
          (dotenv.env['VITE_SITE_URL'] ?? dotenv.env['SITE_URL'] ?? '').trim();
      if (fromEnv.isNotEmpty) return _withoutTrailingSlash(fromEnv);
    }

    // Vite dev server. Android emulators reach the host loopback via 10.0.2.2.
    return defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:3000'
        : 'http://127.0.0.1:3000';
  }

  /// Chrome-free skeleton viewer page rendered inside the native app.
  ///
  /// [stageOnly] drops the web heading, callout and topic list so the native
  /// screen can supply them instead of showing them twice.
  static Uri anatomyEmbedUri(String languageCode, {bool stageOnly = true}) {
    final lang = languageCode == 'es' ? 'es' : 'en';
    return Uri.parse('$siteBaseUrl/embed/anatomy-viewer').replace(
      queryParameters: {
        'lang': lang,
        if (stageOnly) 'mode': 'stage',
      },
    );
  }

  static String _withoutTrailingSlash(String value) {
    return value.trim().replaceAll(RegExp(r'/+$'), '');
  }

  static String get patientPortalUrl {
    if (!dotenv.isInitialized) return '';
    return (dotenv.env['VITE_PATIENT_PORTAL_URL'] ?? '').trim();
  }

  static String get googleReviewsUrl {
    if (!dotenv.isInitialized) return '';
    final fromEnv = (dotenv.env['VITE_GOOGLE_REVIEWS_URL'] ?? '').trim();
    if (fromEnv.isNotEmpty) return fromEnv;
    return '';
  }

  /// Patient portal REST API (`/auth`, `/appointments`, `/orders`).
  static String get apiBaseUrl {
    const fromDefine = String.fromEnvironment('API_URL', defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine.replaceAll(RegExp(r'/$'), '');

    if (dotenv.isInitialized) {
      final fromEnv = (dotenv.env['VITE_API_URL'] ?? dotenv.env['API_URL'] ?? '').trim();
      if (fromEnv.isNotEmpty) return fromEnv.replaceAll(RegExp(r'/$'), '');
    }
    return 'http://127.0.0.1:4000/api';
  }

  static bool get hasApi => apiBaseUrl.isNotEmpty;

  static bool get hasPatientPortal => patientPortalUrl.isNotEmpty;
}
