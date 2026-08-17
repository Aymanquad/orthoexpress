import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orthoexpress_app/app.dart';
import 'package:orthoexpress_app/data/content_repository.dart';
import 'package:orthoexpress_app/data/locations.dart';
import 'package:orthoexpress_app/data/service_details_repository.dart';
import 'package:orthoexpress_app/data/services.dart';
import 'package:orthoexpress_app/core/widgets/app_shell.dart';
import 'package:orthoexpress_app/providers/accessibility_provider.dart';
import 'package:orthoexpress_app/providers/cart_provider.dart';
import 'package:orthoexpress_app/providers/language_provider.dart';
import 'package:orthoexpress_app/providers/orders_provider.dart';
import 'package:orthoexpress_app/providers/portal_auth_provider.dart';

Widget _app() {
  final orders = OrdersProvider();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider.value(value: orders),
      ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ChangeNotifierProvider(create: (_) => PortalAuthProvider(orders: orders)),
    ],
    child: const OrthoExpressApp(),
  );
}

Future<void> _open(WidgetTester tester, String path) async {
  final context = tester.element(find.byType(AppShell));
  GoRouter.of(context).go(path);
  await tester.pumpAndSettle();
  expect(
    tester.takeException(),
    isNull,
    reason: 'Exception opening $path',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ServiceDetailRepository.ensureLoaded();
    await ContentRepository.ensureLoaded();
  });

  testWidgets('Every shell page opens without exceptions', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final paths = <String>[
      '/home',
      '/services',
      ...allServices.map((s) => '/services/${s.slug}'),
      '/shop',
      '/shop/cart',
      '/shop/checkout',
      '/shop/orders',
      '/shop/order-failure',
      '/locations',
      ...locations.map((l) => '/locations/${l.slug}'),
      '/more',
      '/more/about',
      '/more/workers-comp',
      '/more/lawyers',
      '/more/book-appointment',
      '/more/blogs',
      ...ContentRepository.blogs.map((b) => '/more/blogs/${b.slug}'),
      '/more/contact-us',
      '/more/payment',
      '/more/telehealth',
      '/more/after-your-visit',
      '/more/patient-portal',
      '/more/portal/login',
      '/more/portal',
      '/more/portal/appointments',
      '/more/technology',
      '/more/faqs',
      '/more/careers',
      '/more/news',
      '/more/privacy-policy',
      '/more/terms',
      '/more/accessibility',
      '/more/workers-comp',
    ];

    for (final path in paths) {
      await _open(tester, path);
    }

    await _open(tester, '/services/not-a-real-service');
    expect(find.text('404'), findsOneWidget);

    await _open(tester, '/locations/not-a-real-city');
    expect(find.text('404'), findsOneWidget);
  });

  test('mapAppPath sends web links into Flutter shell routes', () {
    expect(mapAppPath('/workers-comp'), '/more/workers-comp');
    expect(mapAppPath('/patient-portal'), '/more/patient-portal');
    expect(mapAppPath('/portal'), '/more/portal');
    expect(mapAppPath('/portal/login'), '/more/portal/login');
    expect(mapAppPath('/portal/appointments'), '/more/portal/appointments');
    expect(mapAppPath('/lawyers'), '/more/lawyers');
    expect(mapAppPath('/book-appointment'), '/more/book-appointment');
    expect(mapAppPath('/contact-us'), '/more/contact-us');
    expect(mapAppPath('/technology#orthochat'), '/more/technology');
    expect(mapAppPath('/blogs/recovery-after-surgery'), '/more/blogs/recovery-after-surgery');
    expect(mapAppPath('/services/mri-digital-imaging'), '/services/mri-digital-imaging');
  });
}
