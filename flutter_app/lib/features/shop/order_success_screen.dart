import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/products.dart';
import '../../data/shop_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/orders_provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final order = context.watch<OrdersProvider>().getById(orderId);

    if (order == null) {
      return Center(
        child: ResponsivePage(
          alignTop: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ShopLabels.orderNotFound(lang), style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(ShopLabels.orderNotFoundText(lang), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/shop'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                child: Text(ShopLabels.goToShop(lang)),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: ResponsivePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, color: AppColors.accent, size: 64),
            const SizedBox(height: 16),
            Text(
              ShopLabels.orderConfirmed(lang),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              ShopLabels.orderThankYou(lang, order.customer.firstName),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${lang == 'es' ? 'ID de pedido' : 'Order ID'}: ${order.id}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(ShopLabels.orderDetails(lang), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('${item.name} × ${item.quantity}'),
                            ),
                            Text(formatPrice(item.lineTotal)),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ShopLabels.totalPaid(lang), style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          formatPrice(order.totals.total),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${ShopLabels.shippingTo(lang)}: ${order.customer.address}, '
                      '${order.customer.city}, ${order.customer.state} ${order.customer.zip}',
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ShopLabels.confirmationEmail(lang, order.customer.email),
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (order.payment != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${ShopLabels.paymentInfo(lang)}: ${ShopLabels.paymentDemo(lang)}'
                        '${order.payment!.last4 != null ? ' •••• ${order.payment!.last4}' : ''}',
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/shop/orders'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(ShopLabels.viewAllOrders(lang)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.go('/shop'),
              child: Text(ShopLabels.continueShopping(lang)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
