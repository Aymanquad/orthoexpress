import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/widgets/app_shell.dart';
import '../features/about/about_screen.dart';
import '../features/blogs/blogs_screen.dart';
import '../features/content/content_screens.dart';
import '../features/forms/book_appointment_screen.dart';
import '../features/forms/contact_us_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lawyers/lawyers_screen.dart';
import '../features/locations/location_detail_screen.dart';
import '../features/locations/locations_screen.dart';
import '../features/more/more_screen.dart';
import '../features/doctors/doctor_call_screen.dart';
import '../features/doctors/doctor_chat_screen.dart';
import '../features/doctors/doctor_inbox_screen.dart';
import '../features/doctors/doctor_login_screen.dart';
import '../features/doctors/doctors_screen.dart';
import '../features/portal/portal_appointments_screen.dart';
import '../features/portal/portal_dashboard_screen.dart';
import '../features/portal/portal_login_screen.dart';
import '../features/portal/portal_profile_screen.dart';
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
import '../providers/doctor_auth_provider.dart';
import '../providers/portal_auth_provider.dart';
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
      return _authRedirect(context, state);
    },
  );
}

String? _authRedirect(BuildContext context, GoRouterState state) {
  final path = state.uri.path;
  final conversationId = state.uri.queryParameters['c'];

  PortalAuthProvider? patientAuth;
  DoctorAuthProvider? doctorAuth;
  try {
    patientAuth = Provider.of<PortalAuthProvider>(context, listen: false);
    doctorAuth = Provider.of<DoctorAuthProvider>(context, listen: false);
  } catch (_) {
    // Providers not ready — don't bounce navigation.
    return null;
  }
  if (patientAuth.loading || doctorAuth.loading) return null;

  final isPatientLogin = path == '/more/portal/login';
  final isPatientProtected = path == '/more/portal' ||
      path == '/more/portal/appointments' ||
      path == '/more/portal/profile' ||
      path == '/more/doctors' ||
      path.startsWith('/more/doctors/call/');
  final isPatientChat =
      path.startsWith('/more/doctors/chat/') && conversationId == null;
  final isDoctorLogin = path == '/more/doctors/login';
  final isDoctorInbox = path == '/more/doctors/inbox';
  final isDoctorChat =
      path.startsWith('/more/doctors/chat/') && conversationId != null;

  if (isPatientProtected && !patientAuth.isAuthenticated) {
    return '/more/portal/login';
  }
  if (isPatientChat && !patientAuth.isAuthenticated) {
    return '/more/portal/login';
  }
  // Prefer Account hub over Home so a leftover login route doesn't fight tab nav.
  if (isPatientLogin && patientAuth.isAuthenticated) return '/more';

  if (isDoctorLogin && doctorAuth.isAuthenticated) return '/more/doctors/inbox';
  if (isDoctorInbox && !doctorAuth.isAuthenticated) return '/more/doctors/login';
  if (isDoctorChat) {
    if (!doctorAuth.isAuthenticated) return '/more/doctors/login';
    final parts = path.split('/');
    // /more/doctors/chat/:doctorId
    final pathDoctorId = parts.length >= 5 ? parts[4] : '';
    if (pathDoctorId.isNotEmpty &&
        doctorAuth.doctor?.id != null &&
        doctorAuth.doctor!.id != pathDoctorId) {
      return '/more/doctors/inbox';
    }
  }

  return null;
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
    path: 'lawyers',
    builder: (context, state) => const LawyersScreen(),
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
    path: 'doctors',
    builder: (context, state) => const DoctorsScreen(),
    routes: [
      GoRoute(
        path: 'login',
        builder: (context, state) => const DoctorLoginScreen(),
      ),
      GoRoute(
        path: 'inbox',
        builder: (context, state) => const DoctorInboxScreen(),
      ),
      GoRoute(
        path: 'call/:doctorId',
        builder: (context, state) => DoctorCallScreen(
          doctorId: state.pathParameters['doctorId']!,
        ),
      ),
      GoRoute(
        path: 'chat/:doctorId',
        builder: (context, state) => DoctorChatScreen(
          doctorId: state.pathParameters['doctorId']!,
          conversationId: state.uri.queryParameters['c'],
        ),
      ),
    ],
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
    path: 'portal',
    builder: (context, state) => const PortalDashboardScreen(),
    routes: [
      GoRoute(
        path: 'login',
        builder: (context, state) => const PortalLoginScreen(),
      ),
      GoRoute(
        path: 'appointments',
        builder: (context, state) => const PortalAppointmentsScreen(),
      ),
      GoRoute(
        path: 'profile',
        builder: (context, state) => const PortalProfileScreen(),
      ),
    ],
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
