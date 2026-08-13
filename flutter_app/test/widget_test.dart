import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:orthoexpress_app/app.dart';
import 'package:orthoexpress_app/data/content_repository.dart';
import 'package:orthoexpress_app/data/service_details_repository.dart';
import 'package:orthoexpress_app/providers/cart_provider.dart';
import 'package:orthoexpress_app/providers/language_provider.dart';
import 'package:orthoexpress_app/providers/orders_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ServiceDetailRepository.ensureLoaded();
    await ContentRepository.ensureLoaded();
  });

  testWidgets('App loads home tab', (WidgetTester tester) async {
    final lang = LanguageProvider();
    final cart = CartProvider();
    final orders = OrdersProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: lang),
          ChangeNotifierProvider.value(value: cart),
          ChangeNotifierProvider.value(value: orders),
        ],
        child: const OrthoExpressApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Walk-In Orthopedic Care'), findsOneWidget);
  });
}
