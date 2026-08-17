import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../data/clinic.dart';
import '../../data/locations.dart';
import '../../data/portal_api.dart';

String todayDateString() {
  final today = DateTime.now();
  return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
}

const _emailPattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
const _phonePattern = r'^[\d\s\-+().]{7,}$';

/// Formspree ID from `flutter_app/.env` (`VITE_FORMSPREE_FORM_ID`),
/// with optional `--dart-define=FORMSPREE_FORM_ID=xxx` override.
String get formspreeFormId {
  const fromDefine = String.fromEnvironment('FORMSPREE_FORM_ID', defaultValue: '');
  if (fromDefine.isNotEmpty) return fromDefine;

  if (!dotenv.isInitialized) return '';

  final fromEnv = dotenv.env['VITE_FORMSPREE_FORM_ID'] ??
      dotenv.env['FORMSPREE_FORM_ID'] ??
      '';
  return fromEnv.trim();
}

class ContactFormData {
  String name = '';
  String email = '';
  String phone = '';
  String message = '';
  bool consent = false;
}

class AppointmentFormData {
  String name = '';
  String email = '';
  String phone = '';
  String location = '';
  String preferredDate = '';
  String preferredTime = '';
  String reason = '';
  bool consent = false;
}

class FormSubmitResult {
  final bool success;
  final bool viaMailto;
  final String? errorMessage;

  const FormSubmitResult({
    required this.success,
    this.viaMailto = false,
    this.errorMessage,
  });
}

Map<String, String> validateContactForm(ContactFormData data, String lang) {
  final errors = <String, String>{};
  final es = lang == 'es';

  if (data.name.trim().isEmpty) {
    errors['name'] = es ? 'El nombre es obligatorio' : 'Name is required';
  }

  if (data.email.trim().isEmpty) {
    errors['email'] = es ? 'El correo es obligatorio' : 'Email is required';
  } else if (!RegExp(_emailPattern).hasMatch(data.email.trim())) {
    errors['email'] = es ? 'Correo inválido' : 'Invalid email address';
  }

  if (data.phone.trim().isNotEmpty && !RegExp(_phonePattern).hasMatch(data.phone.trim())) {
    errors['phone'] = es ? 'Teléfono inválido' : 'Invalid phone number';
  }

  if (data.message.trim().isEmpty) {
    errors['message'] = es ? 'El mensaje es obligatorio' : 'Message is required';
  } else if (data.message.trim().length < 10) {
    errors['message'] = es
        ? 'El mensaje debe tener al menos 10 caracteres'
        : 'Message must be at least 10 characters';
  }

  if (!data.consent) {
    errors['consent'] = es ? 'Debe aceptar el consentimiento' : 'Consent is required';
  }

  return errors;
}

Map<String, String> validateAppointmentForm(AppointmentFormData data, String lang) {
  final errors = <String, String>{};
  final es = lang == 'es';
  final today = DateTime.now();
  final todayStr =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

  if (data.name.trim().isEmpty) {
    errors['name'] = es ? 'El nombre completo es obligatorio' : 'Full name is required';
  }

  if (data.phone.trim().isEmpty) {
    errors['phone'] = es ? 'El teléfono es obligatorio' : 'Phone is required';
  } else if (!RegExp(_phonePattern).hasMatch(data.phone.trim())) {
    errors['phone'] = es ? 'Teléfono inválido' : 'Invalid phone number';
  }

  if (data.email.trim().isEmpty) {
    errors['email'] = es ? 'El correo es obligatorio' : 'Email is required';
  } else if (!RegExp(_emailPattern).hasMatch(data.email.trim())) {
    errors['email'] = es ? 'Correo inválido' : 'Invalid email address';
  }

  if (data.location.isEmpty) {
    errors['location'] = es ? 'Seleccione una ubicación' : 'Please select a location';
  }

  if (data.preferredDate.isEmpty) {
    errors['preferredDate'] = es ? 'La fecha es obligatoria' : 'Preferred date is required';
  } else if (data.preferredDate.compareTo(todayStr) < 0) {
    errors['preferredDate'] = es ? 'La fecha no puede ser en el pasado' : 'Date cannot be in the past';
  }

  if (!data.consent) {
    errors['consent'] = es ? 'Debe aceptar el consentimiento' : 'Consent is required';
  }

  return errors;
}

Future<FormSubmitResult> _submitToFormspree(Map<String, dynamic> payload) async {
  if (formspreeFormId.isEmpty) {
    return const FormSubmitResult(
      success: false,
      errorMessage: 'Form endpoint is not configured.',
    );
  }

  try {
    final response = await http.post(
      Uri.parse('https://formspree.io/f/$formspreeFormId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return const FormSubmitResult(success: true);
    }

    final body = jsonDecode(response.body);
    final message = body is Map && body['error'] != null
        ? body['error'].toString()
        : 'Unable to send your request. Please try again.';
    return FormSubmitResult(success: false, errorMessage: message);
  } catch (_) {
    return const FormSubmitResult(
      success: false,
      errorMessage: 'Unable to send your request. Please try again.',
    );
  }
}

Future<FormSubmitResult> submitContactForm(ContactFormData data) async {
  final payload = {
    '_subject': 'Contact form — ${data.name}',
    'formType': 'Contact Us',
    'name': data.name,
    'email': data.email,
    'phone': data.phone.isEmpty ? 'Not provided' : data.phone,
    'message': data.message,
  };

  if (formspreeFormId.isNotEmpty) {
    return _submitToFormspree(payload);
  }

  return FormSubmitResult(
    success: true,
    viaMailto: true,
  );
}

String contactMailtoSubject(ContactFormData data) => 'Contact from ${data.name}';

String contactMailtoBody(ContactFormData data) =>
    'Name: ${data.name}\nEmail: ${data.email}\nPhone: ${data.phone.isEmpty ? 'N/A' : data.phone}\n\nMessage:\n${data.message}';

Future<FormSubmitResult> submitAppointmentForm(AppointmentFormData data) async {
  final loc = getLocationBySlug(data.location);
  final locationLabel = loc != null ? '${loc.name} — ${loc.city}' : data.location;

  final preferredParts = [
    if (data.preferredDate.isNotEmpty) data.preferredDate,
    if (data.preferredTime.isNotEmpty) data.preferredTime,
  ];
  final preferredAt = preferredParts.join(' ');

  try {
    await PortalApi.requestAppointment(
      name: data.name,
      phone: data.phone,
      email: data.email,
      locationName: locationLabel,
      preferredAt: preferredAt.isEmpty ? null : preferredAt,
      reason: data.reason.isEmpty ? null : data.reason,
      consent: data.consent,
    );
    return const FormSubmitResult(success: true);
  } catch (_) {
    // Fall through to Formspree / mailto, same as the website.
  }

  final payload = {
    '_subject': 'Appointment request — ${data.name}',
    'formType': 'Book Appointment',
    'name': data.name,
    'email': data.email,
    'phone': data.phone,
    'location': locationLabel,
    'preferredDate': data.preferredDate,
    'preferredTime': data.preferredTime.isEmpty ? 'No preference' : data.preferredTime,
    'reason': data.reason.isEmpty ? 'Not provided' : data.reason,
  };

  if (formspreeFormId.isNotEmpty) {
    return _submitToFormspree(payload);
  }

  return const FormSubmitResult(success: true, viaMailto: true);
}

String appointmentMailtoSubject(AppointmentFormData data) => 'Appointment request from ${data.name}';

String appointmentMailtoBody(AppointmentFormData data) {
  final loc = getLocationBySlug(data.location);
  final locationLabel = loc != null ? '${loc.name} — ${loc.city}' : data.location;
  return 'Name: ${data.name}\n'
      'Email: ${data.email}\n'
      'Phone: ${data.phone}\n'
      'Location: $locationLabel\n'
      'Preferred Date: ${data.preferredDate}\n'
      'Preferred Time: ${data.preferredTime.isEmpty ? 'No preference' : data.preferredTime}\n\n'
      'Reason:\n${data.reason.isEmpty ? 'Not provided' : data.reason}';
}

String mailtoUri(String subject, String body) {
  final email = ClinicData.email;
  return 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
}
