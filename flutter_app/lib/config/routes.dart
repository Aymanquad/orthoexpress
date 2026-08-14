import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_shell.dart';
import '../features/about/about_screen.dart';
import '../features/blogs/blogs_screen.dart';
import '../features/content/content_screens.dart';
import '../features/forms/book_appointment_screen.dart';
import '../features/forms/contact_us_screen.dart';
import '../features/home/home_screen.dart';
import '../features/locations/location_detail_screen.dart';
import '../features/locations/locations_screen.dart';
import '../features/more/more_screen.dart';
import '../features/services/service_detail_screen.dart';
import '../features/services/services_screen.dart';
import '../features/shop/cart_screen.dart';
import '../features/shop/checkout_screen.dart';
import '../features/shop/order_failure_screen.dart';
import '../features/shop/order_success_screen.dart';
import '../features/shop/orders_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/shared/not_found_screen.dart';
import '../features/workers_comp/workers_comp_screen.dart';
import 'route_titles.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ServicesScreen()),
                routes: [
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) => ServiceDetailScreen(
                      slug: state.pathParameters['slug']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShopScreen()),
                routes: [
                  GoRoute(
                    path: 'cart',
                    builder: (context, state) => const CartScreen(),
                  ),
                  GoRoute(
                    path: 'checkout',
                    builder: (context, state) => const CheckoutScreen(),
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const OrdersScreen(),
                  ),
                  GoRoute(
                    path: 'order-success/:orderId',
                    builder: (context, state) => OrderSuccessScreen(
                      orderId: state.pathParameters['orderId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'order-failure',
                    builder: (context, state) => OrderFailureScreen(
                      message: state.extra as String?,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/locations',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LocationsScreen()),
                routes: [
                  GoRoute(
                    path: ':slug',
                    builder: (context, state) => LocationDetailScreen(
                      slug: state.pathParameters['slug']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MoreScreen()),
                routes: _moreBranchRoutes,
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final path = state.uri.path;
      if (path == '/') return '/home';
      if (path.startsWith('/order-success/')) {
        final id = path.substring('/order-success/'.length);
        if (id.isNotEmpty) return '/shop/order-success/$id';
      }
      if (path == '/order-failure') return '/shop/order-failure';
      if (path == '/blogs' || path.startsWith('/blogs/')) {
        return '/more$path';
      }
      final legacy = legacyRouteRedirects[path];
      if (legacy != null) return legacy;
      return null;
    },
  );
}

final List<RouteBase> _moreBranchRoutes = [
  GoRoute(
    path: 'about',
    builder: (context, state) => const AboutScreen(),
  ),
  GoRoute(
    path: 'workers-comp',
    builder: (context, state) => const WorkersCompScreen(),
  ),
  GoRoute(
    path: 'book-appointment',
    builder: (context, state) => const BookAppointmentScreen(),
  ),
  GoRoute(
    path: 'blogs',
    builder: (context, state) => const BlogsScreen(),
    routes: [
      GoRoute(
        path: ':slug',
        builder: (context, state) => BlogDetailScreen(
          slug: state.pathParameters['slug']!,
        ),
      ),
    ],
  ),
  GoRoute(
    path: 'contact-us',
    builder: (context, state) => const ContactUsScreen(),
  ),
  GoRoute(
    path: 'payment',
    builder: (context, state) => const PaymentScreen(),
  ),
  GoRoute(
    path: 'telehealth',
    builder: (context, state) => const TelehealthScreen(),
  ),
  GoRoute(
    path: 'after-your-visit',
    builder: (context, state) => const AfterVisitScreen(),
  ),
  GoRoute(
    path: 'patient-portal',
    builder: (context, state) => const PatientPortalScreen(),
  ),
  GoRoute(
    path: 'technology',
    builder: (context, state) => const TechnologyScreen(),
  ),
  GoRoute(
    path: 'faqs',
    builder: (context, state) => const FaqsScreen(),
  ),
  GoRoute(
    path: 'careers',
    builder: (context, state) => const CareersScreen(),
  ),
  GoRoute(
    path: 'news',
    builder: (context, state) => const NewsScreen(),
  ),
  GoRoute(
    path: 'privacy-policy',
    builder: (context, state) => const LegalScreen(type: LegalPageType.privacy),
  ),
  GoRoute(
    path: 'terms',
    builder: (context, state) => const LegalScreen(type: LegalPageType.terms),
  ),
  GoRoute(
    path: 'accessibility',
    builder: (context, state) => const LegalScreen(type: LegalPageType.accessibility),
  ),
];
