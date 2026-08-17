import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/portal.dart';
import '../data/portal_api.dart';
import 'orders_provider.dart';

class PortalAuthProvider extends ChangeNotifier {
  static const _tokenKey = 'orthoexpress_portal_token';

  PortalAuthProvider({required OrdersProvider orders}) : _orders = orders;

  final OrdersProvider _orders;

  PortalPatient? _patient;
  bool _loading = false;

  PortalPatient? get patient => _patient;
  bool get loading => _loading;
  bool get isAuthenticated => _patient != null;

  Future<void> restore() async {
    _loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
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
    PortalApi.token = result.token;
    _patient = result.patient;
    await _syncPatientOrders(result.patient.phone);
    notifyListeners();
    return result.patient;
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
