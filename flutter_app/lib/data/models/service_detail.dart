import '../../core/l10n/localized.dart';

class ServiceDetail {
  final String slug;
  final L10nString title;
  final L10nString description;
  final L10nString overview;
  final L10nList conditions;
  final L10nList treatments;
  final L10nString additionalInfo;
  final String imagePath;
  final String imageFallback;
  final String? heroImagePath;
  final String? bodyImagePath;

  const ServiceDetail({
    required this.slug,
    required this.title,
    required this.description,
    required this.overview,
    required this.conditions,
    required this.treatments,
    required this.additionalInfo,
    required this.imagePath,
    required this.imageFallback,
    this.heroImagePath,
    this.bodyImagePath,
  });

  ServiceDetailView forLang(String lang) {
    final hero = heroImagePath ?? (bodyImagePath == null ? imagePath : null);
    var body = bodyImagePath;
    if (body != null && body == hero) body = null;

    return ServiceDetailView(
      slug: slug,
      title: title.forLang(lang),
      description: description.forLang(lang),
      overview: overview.forLang(lang),
      conditions: conditions.forLang(lang),
      treatments: treatments.forLang(lang),
      additionalInfo: additionalInfo.forLang(lang),
      heroImagePath: hero ?? imagePath,
      bodyImagePath: body,
      imageFallback: imageFallback,
    );
  }
}

class ServiceDetailView {
  final String slug;
  final String title;
  final String description;
  final String overview;
  final List<String> conditions;
  final List<String> treatments;
  final String additionalInfo;
  final String heroImagePath;
  final String? bodyImagePath;
  final String imageFallback;

  const ServiceDetailView({
    required this.slug,
    required this.title,
    required this.description,
    required this.overview,
    required this.conditions,
    required this.treatments,
    required this.additionalInfo,
    required this.heroImagePath,
    this.bodyImagePath,
    required this.imageFallback,
  });
}
