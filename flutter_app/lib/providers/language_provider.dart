import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _storageKey = 'orthoexpress_lang';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isSpanish => _locale.languageCode == 'es';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == 'es') {
      _locale = const Locale('es');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final next = locale.languageCode == 'es' ? const Locale('es') : const Locale('en');
    if (_locale == next) return;
    _locale = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _locale.languageCode);
    notifyListeners();
  }

  Future<void> toggle() async {
    await setLocale(isSpanish ? const Locale('en') : const Locale('es'));
  }
}
