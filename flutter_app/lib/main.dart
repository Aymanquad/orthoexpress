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
import 'providers/chat_provider.dart';
import 'providers/doctor_auth_provider.dart';
import 'providers/portal_auth_provider.dart';
import 'providers/workplace_auth_provider.dart';
// 3D anatomy viewer temporarily disabled.
// import 'features/home/widgets/anatomy_embed_view.dart';
// import 'features/home/widgets/skeleton_3d.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 3D anatomy viewer temporarily disabled.
  // registerSkeleton3d();

  await dotenv.load(fileName: '.env', isOptional: true);
  // Only used when VITE_SITE_URL is set. Physical phones cannot load the
  // emulator host, so the bundled three_js viewer is the default.
  // registerAnatomyEmbed();

  final lang = LanguageProvider();
  final cart = CartProvider();
  final orders = OrdersProvider();
  final a11y = AccessibilityProvider();
  final portalAuth = PortalAuthProvider(orders: orders);
  final doctorAuth = DoctorAuthProvider();
  final workplaceAuth = WorkplaceAuthProvider();
  final chat = ChatProvider();
  await lang.load();
  await cart.load();
  await orders.load();
  await a11y.load();
  await portalAuth.restore();
  await doctorAuth.restore();
  await workplaceAuth.restore();
  await chat.load();
  await ServiceDetailRepository.ensureLoaded();
  await ContentRepository.ensureLoaded();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: lang),
        ChangeNotifierProvider.value(value: cart),
        ChangeNotifierProvider.value(value: orders),
        ChangeNotifierProvider.value(value: a11y),
        ChangeNotifierProvider.value(value: portalAuth),
        ChangeNotifierProvider.value(value: doctorAuth),
        ChangeNotifierProvider.value(value: workplaceAuth),
        ChangeNotifierProvider.value(value: chat),
      ],
      child: const OrthoExpressApp(),
    ),
  );
}
