import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:orthoexpress_app/data/content_repository.dart';
import 'package:orthoexpress_app/data/service_details_repository.dart';
import 'package:orthoexpress_app/providers/orders_provider.dart';
import 'package:orthoexpress_app/app.dart';
import 'package:orthoexpress_app/features/shop/shop_screen.dart';
import 'package:orthoexpress_app/providers/cart_provider.dart';
import 'package:orthoexpress_app/providers/language_provider.dart';

/// Common device widths for regression checks (phones + tablets).
const _viewports = <Size>[
  Size(320, 568), // iPhone SE
  Size(360, 780), // compact Android
  Size(390, 844), // iPhone 14
  Size(412, 915), // large phone
  Size(600, 960), // small tablet portrait
  Size(768, 1024), // iPad portrait
  Size(834, 1194), // iPad Pro 11"
  Size(1024, 768), // tablet landscape
  Size(1280, 800), // large tablet / desktop
];

Widget _appWrapper() {
  final lang = LanguageProvider();
  final cart = CartProvider();
  final orders = OrdersProvider();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: lang),
      ChangeNotifierProvider.value(value: cart),
      ChangeNotifierProvider.value(value: orders),
    ],
    child: const OrthoExpressApp(),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ServiceDetailRepository.ensureLoaded();
    await ContentRepository.ensureLoaded();
  });

  testWidgets('Home renders without overflow on common viewports', (tester) async {
    for (final size in _viewports) {
      await _setViewport(tester, size);
      await tester.pumpWidget(_appWrapper());
      await tester.pumpAndSettle();

      expect(find.text('Walk-In Orthopedic Care'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Overflow at ${size.width}x${size.height}');
    }
  });

  testWidgets('Shop grid renders without overflow on phone and tablet', (tester) async {
    final cart = CartProvider();
    final lang = LanguageProvider();

    for (final size in [const Size(360, 780), const Size(834, 1194)]) {
      await _setViewport(tester, size);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: cart),
            ChangeNotifierProvider.value(value: lang),
          ],
          child: MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: size),
              child: const Scaffold(body: ShopScreen()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ortho Shop'), findsOneWidget);
      expect(
        find.text('Add to Cart').evaluate().isNotEmpty ||
            find.text('Add').evaluate().isNotEmpty,
        isTrue,
      );
      expect(tester.takeException(), isNull, reason: 'Shop overflow at ${size.width}');
    }
  });

  testWidgets('Tablet uses navigation rail', (tester) async {
    await _setViewport(tester, const Size(834, 1194));
    await tester.pumpWidget(_appWrapper());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Phone uses bottom navigation bar', (tester) async {
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_appWrapper());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });
}
