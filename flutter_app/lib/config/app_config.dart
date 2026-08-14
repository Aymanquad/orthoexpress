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

  static bool get hasPatientPortal => patientPortalUrl.isNotEmpty;
}
