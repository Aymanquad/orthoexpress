import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/content_repository.dart';
import 'data/service_details_repository.dart';
import 'providers/accessibility_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
import 'providers/orders_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env', isOptional: true);

  final lang = LanguageProvider();
  final cart = CartProvider();
  final orders = OrdersProvider();
  final a11y = AccessibilityProvider();
  await lang.load();
  await cart.load();
  await orders.load();
  await a11y.load();
  await ServiceDetailRepository.ensureLoaded();
  await ContentRepository.ensureLoaded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: lang),
        ChangeNotifierProvider.value(value: cart),
        ChangeNotifierProvider.value(value: orders),
        ChangeNotifierProvider.value(value: a11y),
      ],
      child: const OrthoExpressApp(),
    ),
  );
}
