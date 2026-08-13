import '../data/clinic.dart';
import '../data/content_repository.dart';
import '../data/locations.dart';
import '../data/page_labels.dart';
import '../data/service_labels.dart';
import '../data/shop_labels.dart';

/// App bar titles and tab-root detection for shell navigation.
class RouteTitles {
  static const tabRoots = {
    '/home',
    '/services',
    '/shop',
    '/locations',
    '/more',
  };

  static bool isTabRoot(String path) => tabRoots.contains(path);

  static String forPath(String path, String lang) {
    if (isTabRoot(path)) return ClinicData.name;

    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return ClinicData.name;

    switch (segments.first) {
      case 'more':
        return _moreTitle(segments, lang);
      case 'services':
        if (segments.length > 1) {
          return ServiceLabels.name(segments[1], lang);
        }
        return 'Services';
      case 'locations':
        if (segments.length > 1) {
          final loc = getLocationBySlug(segments[1]);
          return loc?.name ?? 'Location';
        }
        return 'Locations';
      case 'shop':
        return _shopTitle(segments, lang);
      default:
        return ClinicData.name;
    }
  }

  static String _moreTitle(List<String> segments, String lang) {
    if (segments.length < 2) return 'More';
    switch (segments[1]) {
      case 'about':
        return AboutLabels.title.forLang(lang);
      case 'workers-comp':
        return ServiceLabels.name('workers-comp', lang);
      case 'book-appointment':
        return lang == 'es' ? 'Cita' : 'Appointment';
      case 'blogs':
        if (segments.length > 2) {
          final blog = ContentRepository.blogBySlug(segments[2]);
          return blog?.title.forLang(lang) ?? (lang == 'es' ? 'Blog' : 'Blog');
        }
        return lang == 'es' ? 'Blogs' : 'Blogs';
      case 'contact-us':
        return lang == 'es' ? 'Contáctenos' : 'Contact Us';
      case 'payment':
        return lang == 'es' ? 'Pagos y seguros' : 'Payment & Insurance';
      case 'telehealth':
        return lang == 'es' ? 'Telesalud' : 'Telehealth';
      case 'after-your-visit':
        return lang == 'es' ? 'Después de su visita' : 'After Your Visit';
      case 'patient-portal':
        return lang == 'es' ? 'Portal del paciente' : 'Patient Portal';
      case 'technology':
        return lang == 'es' ? 'Tecnología' : 'Technology';
      case 'faqs':
        return lang == 'es' ? 'Preguntas frecuentes' : 'FAQs';
      case 'careers':
        return lang == 'es' ? 'Carreras' : 'Careers';
      case 'news':
        return lang == 'es' ? 'Noticias' : 'News';
      case 'privacy-policy':
        return lang == 'es' ? 'Política de privacidad' : 'Privacy Policy';
      case 'terms':
        return lang == 'es' ? 'Términos de servicio' : 'Terms of Service';
      case 'accessibility':
        return lang == 'es' ? 'Accesibilidad' : 'Accessibility';
      default:
        return 'More';
    }
  }

  static String _shopTitle(List<String> segments, String lang) {
    if (segments.length < 2) return lang == 'es' ? 'Tienda' : 'Shop';
    switch (segments[1]) {
      case 'cart':
        return lang == 'es' ? 'Carrito' : 'Cart';
      case 'checkout':
        return lang == 'es' ? 'Pago' : 'Checkout';
      case 'orders':
        return ShopLabels.myOrders(lang);
      case 'order-success':
        return ShopLabels.orderConfirmed(lang);
      case 'order-failure':
        return lang == 'es' ? 'Pago' : 'Payment';
      default:
        return lang == 'es' ? 'Tienda' : 'Shop';
    }
  }
}

/// Maps legacy top-level paths to nested shell routes.
const legacyRouteRedirects = <String, String>{
  '/about': '/more/about',
  '/workers-comp': '/more/workers-comp',
  '/book-appointment': '/more/book-appointment',
  '/blogs': '/more/blogs',
  '/contact-us': '/more/contact-us',
  '/payment': '/more/payment',
  '/telehealth': '/more/telehealth',
  '/after-your-visit': '/more/after-your-visit',
  '/patient-portal': '/more/patient-portal',
  '/technology': '/more/technology',
  '/faqs': '/more/faqs',
  '/careers': '/more/careers',
  '/news': '/more/news',
  '/privacy-policy': '/more/privacy-policy',
  '/terms': '/more/terms',
  '/accessibility': '/more/accessibility',
  '/cart': '/shop/cart',
  '/checkout': '/shop/checkout',
  '/orders': '/shop/orders',
};
