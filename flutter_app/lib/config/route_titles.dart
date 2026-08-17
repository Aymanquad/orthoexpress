import '../data/clinic.dart';
import '../data/content_repository.dart';
import '../data/form_labels.dart';
import '../data/locations.dart';
import '../data/nav_labels.dart';
import '../data/page_labels.dart';
import '../data/portal_labels.dart';
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
    if (isTabRoot(path)) {
      switch (path) {
        case '/home':
          return NavLabels.home.forLang(lang);
        case '/services':
          return NavLabels.services.forLang(lang);
        case '/shop':
          return NavLabels.shop.forLang(lang);
        case '/locations':
          return NavLabels.locations.forLang(lang);
        case '/more':
          return NavLabels.more.forLang(lang);
      }
    }

    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return ClinicData.name;

    switch (segments.first) {
      case 'more':
        return _moreTitle(segments, lang);
      case 'services':
        if (segments.length > 1) {
          return ServiceLabels.name(segments[1], lang);
        }
        return ServicesLabels.title.forLang(lang);
      case 'locations':
        if (segments.length > 1) {
          final loc = getLocationBySlug(segments[1]);
          return loc?.name ?? LocationsLabels.title.forLang(lang);
        }
        return LocationsLabels.title.forLang(lang);
      case 'shop':
        return _shopTitle(segments, lang);
      default:
        return ClinicData.name;
    }
  }

  static String _moreTitle(List<String> segments, String lang) {
    if (segments.length < 2) return NavLabels.more.forLang(lang);
    switch (segments[1]) {
      case 'about':
        return AboutLabels.title.forLang(lang);
      case 'workers-comp':
        return ServiceLabels.name('workers-comp', lang);
      case 'lawyers':
        return LawyersLabels.title.forLang(lang);
      case 'book-appointment':
        return BookLabels.title(lang);
      case 'blogs':
        if (segments.length > 2) {
          final blog = ContentRepository.blogBySlug(segments[2]);
          return blog?.title.forLang(lang) ?? NavLabels.blogs.forLang(lang);
        }
        return ContentRepository.label('blogs', 'title', lang);
      case 'contact-us':
        return ContactLabels.title(lang);
      case 'payment':
        return ContentRepository.label('info', 'paymentTitle', lang);
      case 'telehealth':
        return ContentRepository.patientLabel('telehealth', 'title', lang);
      case 'after-your-visit':
        return ContentRepository.patientLabel('afterVisit', 'title', lang);
      case 'patient-portal':
        return ContentRepository.patientLabel('portal', 'title', lang);
      case 'portal':
        if (segments.length > 2) {
          switch (segments[2]) {
            case 'login':
              return PortalLabels.loginTitle.forLang(lang);
            case 'appointments':
              return PortalLabels.appointmentsTitle.forLang(lang);
          }
        }
        return PortalLabels.dashboardTitle.forLang(lang);
      case 'technology':
        return ContentRepository.patientLabel('technology', 'title', lang);
      case 'faqs':
        return ContentRepository.label('info', 'faqsTitle', lang);
      case 'careers':
        return ContentRepository.label('info', 'careersTitle', lang);
      case 'news':
        return ContentRepository.label('info', 'newsTitle', lang);
      case 'privacy-policy':
        return NavLabels.privacyPolicy.forLang(lang);
      case 'terms':
        return NavLabels.termsOfService.forLang(lang);
      case 'accessibility':
        return ContentRepository.label('info', 'accessibilityTitle', lang);
      default:
        return NavLabels.more.forLang(lang);
    }
  }

  static String _shopTitle(List<String> segments, String lang) {
    if (segments.length < 2) return NavLabels.shop.forLang(lang);
    switch (segments[1]) {
      case 'cart':
        return NavLabels.cart.forLang(lang);
      case 'checkout':
        return NavLabels.checkout.forLang(lang);
      case 'orders':
        return ShopLabels.myOrders(lang);
      case 'order-success':
        return ShopLabels.orderConfirmed(lang);
      case 'order-failure':
        return NavLabels.paymentTitle.forLang(lang);
      default:
        return NavLabels.shop.forLang(lang);
    }
  }
}

/// Maps legacy top-level paths to nested shell routes.
const legacyRouteRedirects = <String, String>{
  '/about': '/more/about',
  '/workers-comp': '/more/workers-comp',
  '/lawyers': '/more/lawyers',
  '/book-appointment': '/more/book-appointment',
  '/blogs': '/more/blogs',
  '/contact-us': '/more/contact-us',
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
  '/privacy-policy': '/more/privacy-policy',
  '/terms': '/more/terms',
  '/accessibility': '/more/accessibility',
  '/cart': '/shop/cart',
  '/checkout': '/shop/checkout',
  '/orders': '/shop/orders',
  '/services/pediatric-care': '/services',
  '/services/auto-injury': '/services/car-motor-vehicle-accident-care',
};
