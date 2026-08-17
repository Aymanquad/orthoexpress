import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/l10n/localized.dart';
import 'clinic.dart';

L10nString _l10n(Map<String, dynamic>? map, [String fallback = '']) {
  if (map == null) return L10nString(en: fallback, es: fallback);
  return L10nString(
    en: (map['en'] as String?) ?? fallback,
    es: (map['es'] as String?) ?? (map['en'] as String?) ?? fallback,
  );
}

/// Loads blogs, FAQs, patient-care, and legal chrome from exported web JSON.
class ContentRepository {
  static Map<String, dynamic>? _pages;
  static Map<String, dynamic>? _labels;

  static Future<void> ensureLoaded() async {
    if (_pages != null && _labels != null) return;
    await reload();
  }

  static Future<void> reload() async {
    final pagesRaw = await rootBundle.loadString('assets/data/content_pages.json');
    final labelsRaw = await rootBundle.loadString('assets/data/content_labels.json');
    _pages = jsonDecode(pagesRaw) as Map<String, dynamic>;
    _labels = jsonDecode(labelsRaw) as Map<String, dynamic>;
  }

  static Map<String, dynamic> get _p {
    final pages = _pages;
    if (pages == null) {
      throw StateError('ContentRepository.ensureLoaded() not called');
    }
    return pages;
  }

  static Map<String, dynamic> get _l {
    final labels = _labels;
    if (labels == null) {
      throw StateError('ContentRepository.ensureLoaded() not called');
    }
    return labels;
  }

  static String label(String section, String key, String lang) {
    final block = _l[section] as Map<String, dynamic>?;
    if (block == null) return key;
    final langMap = (block[lang] ?? block['en']) as Map<String, dynamic>?;
    final value = langMap?[key];
    if (value is String) return _fill(value);
    return key;
  }

  static String patientLabel(String page, String key, String lang) {
    final root = _l['patientCare'] as Map<String, dynamic>?;
    final langMap = (root?[lang] ?? root?['en']) as Map<String, dynamic>?;
    final pageMap = langMap?[page] as Map<String, dynamic>?;
    final value = pageMap?[key];
    if (value is String) return _fill(value);
    return key;
  }

  static String _fill(String value) => value
      .replaceAll('{clinic}', ClinicData.name)
      .replaceAll('{email}', ClinicData.email)
      .replaceAll('{phone}', ClinicData.headquartersPhone);

  static List<BlogPost> get blogs {
    final list = _p['blogs'] as List<dynamic>;
    return list.map((e) {
      final m = e as Map<String, dynamic>;
      return BlogPost(
        slug: m['slug'] as String,
        title: _l10n(m['title'] as Map<String, dynamic>?),
        excerpt: _l10n(m['excerpt'] as Map<String, dynamic>?),
        category: _l10n(m['category'] as Map<String, dynamic>?),
        date: _l10n(m['date'] as Map<String, dynamic>?),
        imagePath: m['imagePath'] as String,
        content: _l10n(m['content'] as Map<String, dynamic>?),
      );
    }).toList();
  }

  static BlogPost? blogBySlug(String slug) {
    try {
      return blogs.firstWhere((b) => b.slug == slug);
    } catch (_) {
      return null;
    }
  }

  static List<String> get insuranceProviders =>
      (_p['insuranceProviders'] as List<dynamic>).cast<String>();

  static List<PricedItem> get selfPayPricing =>
      (_p['selfPayPricing'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return PricedItem(
          id: m['id'] as String,
          name: _l10n(m['name'] as Map<String, dynamic>?),
          price: m['price'] as String,
          note: _l10n(m['note'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<FaqItem> get faqs => (_p['faqs'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return FaqItem(
          id: m['id'] as String,
          specialty: m['specialty'] as String,
          category: _l10n(m['category'] as Map<String, dynamic>?),
          question: _l10n(m['q'] as Map<String, dynamic>?),
          answer: _l10n(m['a'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<FaqSpecialty> get faqSpecialties =>
      (_p['faqSpecialties'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return FaqSpecialty(
          id: m['id'] as String,
          label: _l10n(m['label'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<CareerItem> get careers =>
      (_p['careers'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return CareerItem(
          id: m['id'] as String,
          title: _l10n(m['title'] as Map<String, dynamic>?),
          type: _l10n(m['type'] as Map<String, dynamic>?),
          location: _l10n(m['location'] as Map<String, dynamic>?),
          summary: _l10n(m['summary'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<NewsItem> get newsItems =>
      (_p['newsItems'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return NewsItem(
          id: m['id'] as String,
          date: m['date'] as String,
          tag: _l10n(m['tag'] as Map<String, dynamic>?),
          title: _l10n(m['title'] as Map<String, dynamic>?),
          summary: _l10n(m['summary'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<PatientReview> get patientReviews =>
      (_p['patientReviews'] as List<dynamic>?)?.map((e) {
        final m = e as Map<String, dynamic>;
        return PatientReview(
          name: m['name'] as String,
          when: _l10n(m['when'] as Map<String, dynamic>?),
          text: _l10n(m['text'] as Map<String, dynamic>?),
        );
      }).toList() ??
      const [];

  static List<TitledBlock> get telehealthWhen => _blocks('telehealthWhen');
  static List<TitledBlock> get telehealthSteps => _blocks('telehealthSteps');
  static List<TitledBlock> get technologyFeatures => _blocks('technologyFeatures');
  static List<TitledBlock> get orthochatFeatures => _blocks('orthochatFeatures');

  static List<LinkedStep> get afterVisitSteps =>
      (_p['afterVisitSteps'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return LinkedStep(
          id: m['id'] as String,
          icon: m['icon'] as String? ?? 'clipboard',
          title: _l10n(m['title'] as Map<String, dynamic>?),
          text: _l10n(m['text'] as Map<String, dynamic>?),
          link: m['link'] as String?,
          linkLabel: _l10n(m['linkLabel'] as Map<String, dynamic>?),
        );
      }).toList();

  static List<PortalFeature> get portalFeatures =>
      (_p['portalFeatures'] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return PortalFeature(
          id: m['id'] as String,
          title: _l10n(m['title'] as Map<String, dynamic>?),
          text: _l10n(m['text'] as Map<String, dynamic>?),
          link: m['link'] as String?,
          internal: m['internal'] as bool? ?? true,
        );
      }).toList();

  static List<TitledBlock> _blocks(String key) =>
      (_p[key] as List<dynamic>).map((e) {
        final m = e as Map<String, dynamic>;
        return TitledBlock(
          id: m['id'] as String,
          title: _l10n(m['title'] as Map<String, dynamic>?),
          text: _l10n(m['text'] as Map<String, dynamic>?),
        );
      }).toList();
}

class BlogPost {
  final String slug;
  final L10nString title;
  final L10nString excerpt;
  final L10nString category;
  final L10nString date;
  final String imagePath;
  final L10nString content;

  const BlogPost({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
    required this.imagePath,
    required this.content,
  });
}

class FaqItem {
  final String id;
  final String specialty;
  final L10nString category;
  final L10nString question;
  final L10nString answer;

  const FaqItem({
    required this.id,
    required this.specialty,
    required this.category,
    required this.question,
    required this.answer,
  });
}

class FaqSpecialty {
  final String id;
  final L10nString label;
  const FaqSpecialty({required this.id, required this.label});
}

class CareerItem {
  final String id;
  final L10nString title;
  final L10nString type;
  final L10nString location;
  final L10nString summary;

  const CareerItem({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.summary,
  });
}

class NewsItem {
  final String id;
  final String date;
  final L10nString tag;
  final L10nString title;
  final L10nString summary;

  const NewsItem({
    required this.id,
    required this.date,
    required this.tag,
    required this.title,
    required this.summary,
  });
}

class PatientReview {
  final String name;
  final L10nString when;
  final L10nString text;

  const PatientReview({
    required this.name,
    required this.when,
    required this.text,
  });
}

class PricedItem {
  final String id;
  final L10nString name;
  final String price;
  final L10nString note;

  const PricedItem({
    required this.id,
    required this.name,
    required this.price,
    required this.note,
  });
}

class TitledBlock {
  final String id;
  final L10nString title;
  final L10nString text;

  const TitledBlock({
    required this.id,
    required this.title,
    required this.text,
  });
}

class LinkedStep {
  final String id;
  final String icon;
  final L10nString title;
  final L10nString text;
  final String? link;
  final L10nString linkLabel;

  const LinkedStep({
    required this.id,
    required this.icon,
    required this.title,
    required this.text,
    required this.link,
    required this.linkLabel,
  });
}

class PortalFeature {
  final String id;
  final L10nString title;
  final L10nString text;
  final String? link;
  final bool internal;

  const PortalFeature({
    required this.id,
    required this.title,
    required this.text,
    required this.link,
    required this.internal,
  });
}

/// Maps web paths to Flutter shell routes.
String mapAppPath(String? path) {
  if (path == null || path.isEmpty) return '/home';
  final clean = path.split('#').first;
  if (clean.startsWith('/services/')) return clean;
  if (clean.startsWith('/locations/')) return clean;
  if (clean.startsWith('/blogs/')) return '/more$clean';
  const redirects = {
    '/contact-us': '/more/contact-us',
    '/book-appointment': '/more/book-appointment',
    '/payment': '/more/payment',
    '/telehealth': '/more/telehealth',
    '/after-your-visit': '/more/after-your-visit',
    '/patient-portal': '/more/patient-portal',
    '/portal': '/more/portal',
    '/portal/login': '/more/portal/login',
    '/portal/appointments': '/more/portal/appointments',
    '/technology': '/more/technology',
    '/faqs': '/more/faqs',
    '/careers': '/more/careers',
    '/news': '/more/news',
    '/about': '/more/about',
    '/shop': '/shop',
    '/privacy-policy': '/more/privacy-policy',
    '/terms': '/more/terms',
    '/accessibility': '/more/accessibility',
    '/workers-comp': '/more/workers-comp',
    '/lawyers': '/more/lawyers',
    '/cart': '/shop/cart',
    '/checkout': '/shop/checkout',
    '/orders': '/shop/orders',
  };
  return redirects[clean] ?? clean;
}
