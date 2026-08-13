import 'package:flutter_test/flutter_test.dart';
import 'package:orthoexpress_app/core/forms/form_logic.dart';

void main() {
  group('validateContactForm', () {
    test('requires name, email, message, consent', () {
      final errors = validateContactForm(ContactFormData(), 'en');
      expect(errors.containsKey('name'), isTrue);
      expect(errors.containsKey('email'), isTrue);
      expect(errors.containsKey('message'), isTrue);
      expect(errors.containsKey('consent'), isTrue);
    });

    test('accepts valid contact form', () {
      final data = ContactFormData();
      data.name = 'Jane Doe';
      data.email = 'jane@example.com';
      data.message = 'I have a question about my visit.';
      data.consent = true;

      expect(validateContactForm(data, 'en'), isEmpty);
    });
  });

  group('validateAppointmentForm', () {
    test('rejects past date', () {
      final data = AppointmentFormData();
      data.name = 'Jane Doe';
      data.email = 'jane@example.com';
      data.phone = '(432) 322-8675';
      data.location = 'los-angeles';
      data.preferredDate = '2020-01-01';
      data.consent = true;

      final errors = validateAppointmentForm(data, 'en');
      expect(errors['preferredDate'], isNotNull);
    });

    test('accepts valid appointment form', () {
      final data = AppointmentFormData();
      data.name = 'Jane Doe';
      data.email = 'jane@example.com';
      data.phone = '(432) 322-8675';
      data.location = 'los-angeles';
      data.preferredDate = todayDateString();
      data.consent = true;

      expect(validateAppointmentForm(data, 'en'), isEmpty);
    });
  });

  group('submitContactForm', () {
    test('returns mailto fallback when formspree not configured', () async {
      final data = ContactFormData();
      data.name = 'Jane';
      data.email = 'jane@example.com';
      data.message = 'Hello there!';

      final result = await submitContactForm(data);
      expect(result.success, isTrue);
      expect(result.viaMailto, isTrue);
    });
  });
}
