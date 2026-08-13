import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/shop_labels.dart';
import '../../providers/language_provider.dart';

class OrderFailureScreen extends StatelessWidget {
  final String? message;

  const OrderFailureScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final displayMessage = message ?? ShopLabels.paymentFailedDefault(lang);

    return Center(
      child: ResponsivePage(
        alignTop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            Text(
              ShopLabels.paymentFailedTitle(lang),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(displayMessage, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              ShopLabels.orderHelp(lang),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/shop/checkout'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(ShopLabels.tryAgain(lang)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.go('/shop/cart'),
              child: Text(ShopLabels.backToCart(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
