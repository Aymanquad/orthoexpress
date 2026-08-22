import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'models/order.dart';
import 'models/portal.dart';

class PortalApiException implements Exception {
  final String message;
  final int? status;

  const PortalApiException(this.message, {this.status});

  @override
  String toString() => message;
}

class PortalApi {
  PortalApi._();

  static String? token;

  static Uri _uri(String path) {
    final base = AppConfig.apiBaseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath');
  }

  static Map<String, String> _headers({bool auth = false}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (auth && token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static dynamic _decode(http.Response res) {
    if (res.body.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(res.body);
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    late http.Response res;
    try {
      final uri = _uri(path);
      final headers = _headers(auth: auth);
      final encoded = body == null ? null : jsonEncode(body);
      if (method == 'GET') {
        res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 8));
      } else if (method == 'POST') {
        res = await http
            .post(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 8));
      } else if (method == 'PATCH') {
        res = await http
            .patch(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 8));
      } else {
        throw const PortalApiException('Unsupported method');
      }
    } catch (e) {
      if (e is PortalApiException) rethrow;
      throw const PortalApiException(
        'We could not connect right now. Check your connection and try again.',
      );
    }

    final data = _decode(res);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      final message = data is Map && data['error'] != null
          ? data['error'].toString()
          : 'Request failed';
      throw PortalApiException(message, status: res.statusCode);
    }
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  static Future<void> requestOtp(String phone) async {
    await _send('POST', '/auth/otp/request', body: {'phone': phone});
  }

  static Future<({String token, PortalPatient patient})> verifyOtp(
    String phone,
    String code,
  ) async {
    final data = await _send('POST', '/auth/otp/verify', body: {'phone': phone, 'code': code});
    final nextToken = data['token'] as String?;
    final patientMap = data['patient'] as Map<String, dynamic>?;
    if (nextToken == null || nextToken.isEmpty || patientMap == null) {
      throw const PortalApiException('Verification failed');
    }
    token = nextToken;
    return (token: nextToken, patient: PortalPatient.fromJson(patientMap));
  }

  static Future<PortalPatient> me() async {
    final data = await _send('GET', '/auth/me', auth: true);
    return PortalPatient.fromJson(data['patient'] as Map<String, dynamic>);
  }

  static Future<PortalPatient> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    final body = <String, dynamic>{
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    };
    final data = await _send('PATCH', '/auth/me', body: body, auth: true);
    final patientMap = data['patient'] as Map<String, dynamic>?;
    if (patientMap == null) {
      throw const PortalApiException('Profile update failed');
    }
    return PortalPatient.fromJson(patientMap);
  }

  static Future<void> logout() async {
    try {
      await _send('POST', '/auth/logout', auth: true);
    } catch (_) {
      // Local sign-out still proceeds.
    }
    token = null;
  }

  static Future<List<PortalAppointment>> listAppointments({String filter = 'all'}) async {
    final data = await _send('GET', '/appointments?filter=$filter', auth: true);
    final list = data['appointments'] as List? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(PortalAppointment.fromJson)
        .toList();
  }

  static Future<List<Order>> listOrders() async {
    final data = await _send('GET', '/orders', auth: true);
    final list = data['orders'] as List? ?? const [];
    final orders = <Order>[];
    for (final item in list) {
      if (item is Map<String, dynamic>) {
        final order = Order.tryFromJson(item);
        if (order != null) orders.add(order);
      }
    }
    return orders;
  }

  static Future<void> saveOrder(Order order) async {
    await _send('POST', '/orders', body: order.toJson());
  }

  static Future<List<Map<String, dynamic>>> listPrescriptions() async {
    final data = await _send('GET', '/records/prescriptions', auth: true);
    final list = data['prescriptions'] as List? ?? const [];
    return list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<Map<String, dynamic>> getDemographics() async {
    return _send('GET', '/records/demographics', auth: true);
  }

  static Future<Map<String, dynamic>> updateDemographicsContact(
    Map<String, dynamic> payload,
  ) async {
    return _send('PATCH', '/records/demographics', body: payload, auth: true);
  }

  static Future<void> requestAppointment({
    required String name,
    required String phone,
    required String email,
    required String locationName,
    String? preferredAt,
    String? reason,
    required bool consent,
  }) async {
    await _send('POST', '/appointments/request', body: {
      'name': name,
      'phone': phone,
      'email': email,
      'locationName': locationName,
      'serviceName': 'General visit',
      if (preferredAt != null && preferredAt.isNotEmpty) 'preferredAt': preferredAt,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
      'consent': consent,
    });
  }
}
