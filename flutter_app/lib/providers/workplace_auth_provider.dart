import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/workplace.dart';
import '../data/workplace_api.dart';

class WorkplaceAuthProvider extends ChangeNotifier {
  static const _tokenKey = 'orthoexpress_workplace_token_v1';

  WorkplaceUser? _user;
  bool _loading = false;

  WorkplaceUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin == true;
  bool get loading => _loading;

  bool can(String module, {String access = 'read'}) =>
      _user?.can(module, access: access) ?? false;

  Future<void> restore() async {
    _loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token == null || token.isEmpty) {
        _user = null;
        WorkplaceApi.token = null;
        return;
      }
      WorkplaceApi.token = token;
      _user = await WorkplaceApi.me();
    } catch (_) {
      await _clearToken();
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<WorkplaceUser> login(String email, String password) async {
    final result = await WorkplaceApi.login(email.trim(), password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, result.token);
    WorkplaceApi.token = result.token;
    _user = result.user;
    notifyListeners();
    return result.user;
  }

  Future<void> logout() async {
    await WorkplaceApi.logout();
    await _clearToken();
    _user = null;
    notifyListeners();
  }

  Future<void> _clearToken() async {
    WorkplaceApi.token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
