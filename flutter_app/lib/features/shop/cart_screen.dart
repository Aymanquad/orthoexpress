import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/products.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final lines = cart.cartLines;
    final useSideSummary = context.isTablet;

    return lines.isEmpty
          ? Center(
              child: ResponsivePage(
                alignTop: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 56,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.go('/shop'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                      child: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              ),
            )
          : useSideSummary
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _CartList(lines: lines, cart: cart),
                    ),
                    SizedBox(
                      width: context.isLargeTablet ? 360 : 300,
                      child: _CartSummary(cart: cart),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _CartList(lines: lines, cart: cart)),
                    _CartSummary(cart: cart),
                  ],
                );
  }
}

class _CartList extends StatelessWidget {
  final List<CartLine> lines;
  final CartProvider cart;

  const _CartList({required this.lines, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: context.pagePadding,
      itemCount: lines.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final line = lines[index];
        return _CartLineCard(line: line, cart: cart);
      },
    );
  }
}

class _CartLineCard extends StatelessWidget {
  final CartLine line;
  final CartProvider cart;

  const _CartLineCard({required this.line, required this.cart});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactPhone;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 10 : 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AssetImageWithFallback(
                assetPath: line.product.imagePath,
                width: compact ? 64 : 72,
                height: compact ? 64 : 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: compact ? 13 : 14,
                        ),
                  ),
                  Text(formatPrice(line.product.price)),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.updateQuantity(
                          line.product.id,
                          line.item.quantity - 1,
                        ),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('${line.item.quantity}'),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.updateQuantity(
                          line.product.id,
                          line.item.quantity + 1,
                        ),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatPrice(line.lineTotal),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;

  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.pagePadding,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border(
          top: context.isPhone ? BorderSide(color: AppColors.border) : BorderSide.none,
          left: context.isTablet ? BorderSide(color: AppColors.border) : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (context.isTablet)
            Text('Order summary', style: Theme.of(context).textTheme.titleLarge),
          if (context.isTablet) const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text(formatPrice(cart.subtotal)),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push('/shop/checkout'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}
