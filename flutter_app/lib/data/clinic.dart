/// Clinic brand constants — ported from src/data/clinic.js
class ClinicData {
  static const name = 'OrthoExpress';
  static const tagline = 'Orthopedic Walk-In Clinic and #Teleorthopedics.';
  static const email = 'info@orthoexpress.com';

  static const headquartersPhone = '(432) 322-8675';
  static const headquartersFax = '(432) 218-7726';
  static const headquartersLabel = 'Midland';
  static const headquartersCity = 'Midland, TX';

  static const hoursWeekday = 'Monday – Friday: 9:00 AM – 5:00 PM';
  static const hoursShort = 'Mon – Fri: 9 am – 5 pm';

  static const googleRating = 4.8;
  static const googleReviewCount = 240;
  static const googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=OrthoExpress+Midland+TX';

  static String telLink(String phone) {
    return 'tel:${phone.replaceAll(RegExp(r'[^\d+]+'), '')}';
  }
}
