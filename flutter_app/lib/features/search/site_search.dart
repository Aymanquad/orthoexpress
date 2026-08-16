import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/content_repository.dart';
import '../../data/locations.dart';
import '../../data/service_labels.dart';
import '../../data/services.dart';

class SearchHit {
  final String type;
  final String title;
  final String path;

  const SearchHit({
    required this.type,
    required this.title,
    required this.path,
  });
}

List<SearchHit> buildSearchIndex(String lang) {
  final hits = <SearchHit>[];
  final typeService = lang == 'es' ? 'Servicio' : 'Service';
  final typeLocation = lang == 'es' ? 'Ubicación' : 'Location';
  final typeBlog = 'Blog';
  final typeNews = lang == 'es' ? 'Noticias' : 'News';
  final typePage = lang == 'es' ? 'Página' : 'Page';

  for (final service in allServices) {
    hits.add(SearchHit(
      type: typeService,
      title: ServiceLabels.name(service.slug, lang),
      path: '/services/${service.slug}',
    ));
  }

  for (final loc in locations) {
    hits.add(SearchHit(
      type: typeLocation,
      title: loc.name,
      path: '/locations/${loc.slug}',
    ));
  }

  for (final blog in ContentRepository.blogs) {
    hits.add(SearchHit(
      type: typeBlog,
      title: blog.title.forLang(lang),
      path: '/more/blogs/${blog.slug}',
    ));
  }

  for (final news in ContentRepository.newsItems) {
    hits.add(SearchHit(
      type: typeNews,
      title: news.title.forLang(lang),
      path: '/more/news',
    ));
  }

  const pages = [
    ('Payment & Insurance', 'Pagos y seguros', '/more/payment'),
    ('Telehealth', 'Telesalud', '/more/telehealth'),
    ('After Your Visit', 'Después de su visita', '/more/after-your-visit'),
    ('Patient Portal', 'Portal del paciente', '/more/patient-portal'),
    ('Technology', 'Tecnología', '/more/technology'),
    ('FAQs', 'Preguntas frecuentes', '/more/faqs'),
    ('Careers', 'Carreras', '/more/careers'),
    ('Shop', 'Tienda', '/shop'),
    ('Contact Us', 'Contáctenos', '/more/contact-us'),
    ('About Us', 'Sobre nosotros', '/more/about'),
    ('Book Appointment', 'Reservar cita', '/more/book-appointment'),
  ];

  for (final p in pages) {
    hits.add(SearchHit(
      type: typePage,
      title: lang == 'es' ? p.$2 : p.$1,
      path: p.$3,
    ));
  }

  return hits;
}

class SiteSearchDelegate extends SearchDelegate<void> {
  final String lang;

  SiteSearchDelegate(this.lang);

  @override
  String get searchFieldLabel =>
      lang == 'es' ? 'Buscar servicios, clínicas, blogs…' : 'Search services, clinics, blogs…';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return EmptyState(
        icon: Icons.search_rounded,
        title: lang == 'es' ? 'Escriba para buscar' : 'Type to search',
        message: lang == 'es'
            ? 'Servicios, clínicas, artículos y más.'
            : 'Services, clinics, articles, and more.',
      );
    }

    final results = buildSearchIndex(lang)
        .where((h) => h.title.toLowerCase().contains(q))
        .take(8)
        .toList();

    if (results.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: lang == 'es' ? 'Sin resultados' : 'No results',
        message: lang == 'es'
            ? 'Pruebe con otro término o explore Servicios.'
            : 'Try a different term, or browse Services.',
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final hit = results[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(hit.title),
          subtitle: Text(hit.type),
          onTap: () {
            close(context, null);
            context.push(hit.path);
          },
        );
      },
    );
  }
}
