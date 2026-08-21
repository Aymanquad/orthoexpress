import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/shop/order_utils.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/order.dart';
import '../../data/products.dart';
import '../../data/shop_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final orders = context.watch<OrdersProvider>().orders;

    if (orders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: ShopLabels.noOrdersYet(lang),
        message: ShopLabels.ordersEmptyText(lang),
        actionLabel: ShopLabels.browseShop(lang),
        onAction: () => context.go('/shop'),
      );
    }

    return ListView.separated(
      padding: context.pagePadding,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _OrderCard(order: orders[index], lang: lang),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final String lang;

  const _OrderCard({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    final status = orderStatusInfo(order, lang);
    final count = order.itemCount;
    final itemLabel = count == 1 ? ShopLabels.item(lang) : ShopLabels.items(lang);
    final customerName = '${order.customer.firstName} ${order.customer.lastName}'.trim();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        formatOrderDate(order.createdAt, lang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.isDemo
                          ? AppColors.primarySoft
                          : AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.isDemo ? AppColors.primary : AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              customerName.isEmpty
                  ? '$count $itemLabel'
                  : '$count $itemLabel · $customerName',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: AssetImageWithFallback(
                        assetPath: item.imagePath,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${ShopLabels.qty(lang)} ${item.quantity}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(formatPrice(item.lineTotal)),
                  ],
                ),
              ),
            ),
            const Divider(),
            Text(
              ShopLabels.totalPaid(lang),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              formatPrice(order.totals.total),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
            ),
            if (status.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                status.description,
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/shop/order-success/${order.id}'),
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: Text(ShopLabels.viewReceipt(lang)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
