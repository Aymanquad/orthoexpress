import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime config from `flutter_app/.env` (mirrors web VITE_* vars).
class AppConfig {
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
