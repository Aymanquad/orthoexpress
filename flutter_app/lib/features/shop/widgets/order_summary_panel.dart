import 'package:flutter/material.dart';
import '../../../data/models/order.dart';
import '../../../data/products.dart';
import '../../../data/shop_labels.dart';
import '../../../providers/cart_provider.dart';
import '../../../core/widgets/asset_image.dart';

class OrderSummaryPanel extends StatelessWidget {
  final List<CartLine> lines;
  final OrderTotals totals;
  final String lang;
  final bool showItemImages;

  const OrderSummaryPanel({
    super.key,
    required this.lines,
    required this.totals,
    required this.lang,
    this.showItemImages = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ShopLabels.orderSummary(lang),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...lines.map((line) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      if (showItemImages) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: AssetImageWithFallback(
                            assetPath: line.product.imagePath,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '${ShopLabels.qty(lang)} ${line.item.quantity}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(formatPrice(line.lineTotal)),
                    ],
                  ),
                )),
            const Divider(),
            _row(context, ShopLabels.subtotal(lang), formatPrice(totals.subtotal)),
            _row(context, ShopLabels.shipping(lang), formatPrice(totals.shipping)),
            _row(context, ShopLabels.tax(lang), formatPrice(totals.tax)),
            const SizedBox(height: 8),
            _row(
              context,
              ShopLabels.total(lang),
              formatPrice(totals.total),
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool bold = false}) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
