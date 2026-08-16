import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/products.dart';
import '../../data/shop_labels.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final filtered = _category == 'all'
        ? products
        : products.where((p) => p.category == _category).toList();

    final maxExtent = context.isCompactPhone ? 170.0 : (context.isTablet ? 240.0 : 220.0);
    final aspectRatio = context.shopGridAspectRatio;

    return RefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      color: Theme.of(context).colorScheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
        SliverToBoxAdapter(
          child: ResponsivePage(
            padding: EdgeInsets.fromLTRB(
              context.pagePadding.left,
              20,
              context.pagePadding.right,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ShopLabels.shopEyebrow(lang),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  ShopLabels.shopTitle(lang),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  ShopLabels.shopSubtitle(lang),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(
              context.pagePadding.left,
              8,
              context.pagePadding.right,
              8,
            ),
            child: Row(
              children: productCategories.map((cat) {
                final selected = _category == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      ShopLabels.categoryLabel(cat.id, lang),
                      overflow: TextOverflow.ellipsis,
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _category = cat.id),
                    selectedColor: AppColors.primarySoft,
                    checkmarkColor: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            context.pagePadding.left,
            0,
            context.pagePadding.right,
            context.pagePadding.bottom,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxExtent,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _ProductCard(product: filtered[index], lang: lang),
              childCount: filtered.length,
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final String lang;

  const _ProductCard({required this.product, required this.lang});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final compact = context.isCompactPhone;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: AppColors.bgSoft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AssetImageWithFallback(
                  assetPath: product.imagePath,
                  fit: product.imageVariant == 'wearable'
                      ? BoxFit.cover
                      : BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(compact ? 8 : 10, 8, compact ? 8 : 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: compact ? 12 : 13,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(product.price),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontSize: compact ? 13 : 14,
                  ),
                ),
                const SizedBox(height: 6),
                FilledButton(
                  onPressed: () {
                    cart.addToCart(product.id).then((_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ShopLabels.addedToCart(lang, product.name)),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  child: Text(
                    compact
                        ? ShopLabels.addToCartShort(lang)
                        : ShopLabels.addToCart(lang),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
