import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  static const _storageKey = 'orthoexpress_a11y';

  int _fontStep = 0;
  bool _highContrast = false;
  bool _highlightLinks = false;
  bool _loaded = false;

  int get fontStep => _fontStep;
  bool get highContrast => _highContrast;
  bool get highlightLinks => _highlightLinks;
  bool get loaded => _loaded;

  double get textScaleFactor => 1.0 + _fontStep * 0.08;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _fontStep = (map['fontStep'] as num?)?.toInt() ?? 0;
        _highContrast = map['highContrast'] as bool? ?? false;
        _highlightLinks = map['highlightLinks'] as bool? ?? false;
      } catch (_) {}
    }
    _fontStep = _fontStep.clamp(-1, 3);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'fontStep': _fontStep,
        'highContrast': _highContrast,
        'highlightLinks': _highlightLinks,
      }),
    );
  }

  void increaseFont() {
    if (_fontStep >= 3) return;
    _fontStep++;
    _save();
    notifyListeners();
  }

  void decreaseFont() {
    if (_fontStep <= -1) return;
    _fontStep--;
    _save();
    notifyListeners();
  }

  void toggleHighContrast() {
    _highContrast = !_highContrast;
    _save();
    notifyListeners();
  }

  void toggleHighlightLinks() {
    _highlightLinks = !_highlightLinks;
    _save();
    notifyListeners();
  }

  void reset() {
    _fontStep = 0;
    _highContrast = false;
    _highlightLinks = false;
    _save();
    notifyListeners();
  }
}
