import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/l10n/localized.dart';
import 'models/service_detail.dart';
import 'service_images.dart';

/// Loads service detail content from exported web data (`service_details.json`).
class ServiceDetailRepository {
  static Map<String, ServiceDetail>? _cache;

  static Future<void> ensureLoaded() async {
    if (_cache != null) return;

    final raw = await rootBundle.loadString('assets/data/service_details.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    _cache = decoded.map((slug, value) {
      final map = value as Map<String, dynamic>;
      final images = ServiceImages.forSlug(slug);
      final hero = images.heroImage;
      final body = images.bodyImage;

      return MapEntry(
        slug,
        ServiceDetail(
          slug: slug,
          title: _l10n(map['title'] as Map<String, dynamic>),
          description: _l10n(map['description'] as Map<String, dynamic>),
          overview: _l10n(map['overview'] as Map<String, dynamic>),
          conditions: _l10nList(map['conditions'] as Map<String, dynamic>),
          treatments: _l10nList(map['treatments'] as Map<String, dynamic>),
          additionalInfo: _l10n(map['additionalInfo'] as Map<String, dynamic>),
          imagePath: images.src,
          imageFallback: images.fallback,
          heroImagePath: hero,
          bodyImagePath: body,
        ),
      );
    });
  }

  static ServiceDetailView? getView(String slug, String lang) {
    final detail = _cache?[slug];
    if (detail == null) return null;
    return detail.forLang(lang);
  }

  static L10nString _l10n(Map<String, dynamic> map) {
    return L10nString(
      en: map['en'] as String,
      es: map['es'] as String,
    );
  }

  static L10nList _l10nList(Map<String, dynamic> map) {
    return L10nList(
      en: (map['en'] as List).cast<String>(),
      es: (map['es'] as List).cast<String>(),
    );
  }
}
