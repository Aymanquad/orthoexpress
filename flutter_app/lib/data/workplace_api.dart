import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'models/workplace.dart';
import 'portal_api.dart';

class WorkplaceApi {
  WorkplaceApi._();

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
        res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
      } else if (method == 'POST') {
        res = await http
            .post(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 10));
      } else if (method == 'PATCH') {
        res = await http
            .patch(uri, headers: headers, body: encoded)
            .timeout(const Duration(seconds: 10));
      } else if (method == 'DELETE') {
        res = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 10));
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

  static Future<({String token, WorkplaceUser user})> login(
    String email,
    String password,
  ) async {
    final data = await _send('POST', '/workplace/auth/login', body: {
      'email': email,
      'password': password,
    });
    final nextToken = data['token'] as String?;
    final userMap = data['user'] as Map<String, dynamic>?;
    if (nextToken == null || userMap == null) {
      throw const PortalApiException('Login failed');
    }
    token = nextToken;
    return (token: nextToken, user: WorkplaceUser.fromJson(userMap));
  }

  static Future<WorkplaceUser> me() async {
    final data = await _send('GET', '/workplace/auth/me', auth: true);
    return WorkplaceUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  static Future<void> logout() async {
    try {
      await _send('POST', '/workplace/auth/logout', auth: true);
    } catch (_) {}
    token = null;
  }

  static Future<List<WorkplaceStaffMember>> listStaff() async {
    final data = await _send('GET', '/workplace/staff', auth: true);
    final list = data['staff'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplaceStaffMember.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<WorkplaceStaffMember> createStaff(Map<String, dynamic> payload) async {
    final data = await _send('POST', '/workplace/staff', body: payload, auth: true);
    return WorkplaceStaffMember.fromJson(data['staff'] as Map<String, dynamic>);
  }

  static Future<WorkplaceStaffMember> updateStaff(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final data =
        await _send('PATCH', '/workplace/staff/$id', body: payload, auth: true);
    return WorkplaceStaffMember.fromJson(data['staff'] as Map<String, dynamic>);
  }

  static Future<void> deactivateStaff(String id) async {
    await _send('DELETE', '/workplace/staff/$id', auth: true);
  }

  static Future<List<WorkplaceAppointment>> listAppointments({String? status}) async {
    final q = status == null || status.isEmpty ? '' : '?status=$status';
    final data = await _send('GET', '/workplace/appointments$q', auth: true);
    final list = data['appointments'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplaceAppointment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> updateAppointment(String id, Map<String, dynamic> payload) async {
    await _send('PATCH', '/workplace/appointments/$id', body: payload, auth: true);
  }

  static Future<List<WorkplaceOrder>> listOrders() async {
    final data = await _send('GET', '/workplace/orders', auth: true);
    final list = data['orders'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplaceOrder.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> updateOrder(String id, Map<String, dynamic> payload) async {
    await _send('PATCH', '/workplace/orders/$id', body: payload, auth: true);
  }

  static Future<List<WorkplacePatient>> listPatients({String? q}) async {
    final query = q == null || q.isEmpty ? '' : '?q=${Uri.encodeQueryComponent(q)}';
    final data = await _send('GET', '/workplace/patients$query', auth: true);
    final list = data['patients'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplacePatient.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<List<WorkplacePatient>> listDemographics({String? q}) async {
    final query = q == null || q.isEmpty ? '' : '?q=${Uri.encodeQueryComponent(q)}';
    final data = await _send('GET', '/workplace/demographics/patients$query', auth: true);
    final list = data['patients'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplacePatient.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> updateDemographics(String patientId, Map<String, dynamic> payload) async {
    await _send('PATCH', '/workplace/demographics/$patientId', body: payload, auth: true);
  }

  static Future<List<WorkplacePrescription>> listPrescriptions({String? status}) async {
    final q = status == null || status.isEmpty ? '' : '?status=$status';
    final data = await _send('GET', '/workplace/prescriptions$q', auth: true);
    final list = data['prescriptions'] as List? ?? const [];
    return list
        .whereType<Map>()
        .map((e) => WorkplacePrescription.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> createPrescription(Map<String, dynamic> payload) async {
    await _send('POST', '/workplace/prescriptions', body: payload, auth: true);
  }

  static Future<void> updatePrescription(String id, Map<String, dynamic> payload) async {
    await _send('PATCH', '/workplace/prescriptions/$id', body: payload, auth: true);
  }
}
