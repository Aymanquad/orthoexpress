import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/doctors.dart';

class DoctorAuthProvider extends ChangeNotifier {
  static const _doctorIdKey = 'orthoexpress_doctor_session_id';

  Doctor? _doctor;
  bool _loading = false;

  Doctor? get doctor => _doctor;
  bool get isAuthenticated => _doctor != null;
  bool get loading => _loading;

  Future<void> restore() async {
    _loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_doctorIdKey);
      _doctor = id == null ? null : doctorById(id);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Doctor> login(String username, String password) async {
    final doctor = doctorByUsername(username);
    if (doctor == null || doctor.password != password.trim()) {
      throw Exception('invalid');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_doctorIdKey, doctor.id);
    _doctor = doctor;
    notifyListeners();
    return doctor;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_doctorIdKey);
    _doctor = null;
    notifyListeners();
  }
}
