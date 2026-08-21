import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/portal.dart';
import '../data/portal_api.dart';
import 'orders_provider.dart';

class PortalAuthProvider extends ChangeNotifier {
  static const _tokenKey = 'orthoexpress_portal_token';
  static const _lastPhoneKey = 'orthoexpress_portal_last_phone';
  static const _preferredLocationKey = 'orthoexpress_preferred_location';

  PortalAuthProvider({required OrdersProvider orders}) : _orders = orders;

  final OrdersProvider _orders;

  PortalPatient? _patient;
  bool _loading = false;
  String? _lastPhone;
  String? _preferredLocationSlug;

  PortalPatient? get patient => _patient;
  bool get loading => _loading;
  bool get isAuthenticated => _patient != null;
  String? get lastPhone => _lastPhone;
  String? get preferredLocationSlug => _preferredLocationSlug;

  Future<void> restore() async {
    _loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastPhone = prefs.getString(_lastPhoneKey);
      _preferredLocationSlug = prefs.getString(_preferredLocationKey);
      final token = prefs.getString(_tokenKey);
      if (token == null || token.isEmpty) {
        _patient = null;
        PortalApi.token = null;
        return;
      }
      PortalApi.token = token;
      _patient = await PortalApi.me();
      await _syncPatientOrders(_patient!.phone);
    } catch (_) {
      await _clearToken();
      _patient = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<PortalPatient> login(String phone, String code) async {
    final result = await PortalApi.verifyOtp(phone, code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, result.token);
    await prefs.setString(_lastPhoneKey, phone);
    PortalApi.token = result.token;
    _patient = result.patient;
    _lastPhone = phone;
    await _syncPatientOrders(result.patient.phone);
    notifyListeners();
    return result.patient;
  }

  Future<PortalPatient> refreshProfile() async {
    final patient = await PortalApi.me();
    _patient = patient;
    notifyListeners();
    return patient;
  }

  Future<PortalPatient> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    String? preferredLocationSlug,
  }) async {
    final updated = await PortalApi.updateProfile(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPhoneKey, updated.phone);
    _lastPhone = updated.phone;
    if (preferredLocationSlug != null) {
      if (preferredLocationSlug.isEmpty) {
        await prefs.remove(_preferredLocationKey);
        _preferredLocationSlug = null;
      } else {
        await prefs.setString(_preferredLocationKey, preferredLocationSlug);
        _preferredLocationSlug = preferredLocationSlug;
      }
    }
    _patient = updated;
    notifyListeners();
    return updated;
  }

  Future<void> logout() async {
    await PortalApi.logout();
    await _clearToken();
    _patient = null;
    notifyListeners();
  }

  Future<void> _clearToken() async {
    PortalApi.token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> _syncPatientOrders(String patientPhone) async {
    try {
      final remote = await PortalApi.listOrders();
      await _orders.mergeRemoteOrders(remote);
    } catch (_) {
      // Keep local orders if the API is down.
    }

    final matching = _orders.orders
        .where((o) => _phonesMatch(o.customer.phone, patientPhone))
        .toList();
    await Future.wait(matching.map((o) async {
      try {
        await PortalApi.saveOrder(o);
      } catch (_) {}
    }));
  }
}

bool _phonesMatch(String? a, String? b) {
  final da = (a ?? '').replaceAll(RegExp(r'\D'), '');
  final db = (b ?? '').replaceAll(RegExp(r'\D'), '');
  if (da.isEmpty || db.isEmpty) return false;
  final ta = da.length > 10 ? da.substring(da.length - 10) : da;
  final tb = db.length > 10 ? db.substring(db.length - 10) : db;
  return ta == tb;
}
