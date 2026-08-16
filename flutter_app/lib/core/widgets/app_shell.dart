import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/route_titles.dart';
import '../../config/theme.dart';
import '../../data/nav_labels.dart';
import '../../features/search/site_search.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../utils/responsive.dart';
import 'app_bar_title.dart';
import 'language_chip.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  void _onTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Widget _navIcon(IconData outlined, IconData filled, {bool selected = false}) {
    return Icon(selected ? filled : outlined, size: selected ? 23 : 22);
  }

  List<NavigationDestination> _phoneDestinations(int cartCount, String lang) => [
        NavigationDestination(
          icon: _navIcon(Icons.home_outlined, Icons.home_rounded),
          selectedIcon: _navIcon(Icons.home_outlined, Icons.home_rounded, selected: true),
          label: NavLabels.tabHome.forLang(lang),
        ),
        NavigationDestination(
          icon: _navIcon(Icons.health_and_safety_outlined, Icons.health_and_safety),
          selectedIcon: _navIcon(Icons.health_and_safety_outlined, Icons.health_and_safety, selected: true),
          label: NavLabels.tabServices.forLang(lang),
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
            child: _navIcon(Icons.shopping_bag_outlined, Icons.shopping_bag_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
            child: _navIcon(Icons.shopping_bag_outlined, Icons.shopping_bag, selected: true),
          ),
          label: NavLabels.tabShop.forLang(lang),
        ),
        NavigationDestination(
          icon: _navIcon(Icons.location_on_outlined, Icons.location_on),
          selectedIcon: _navIcon(Icons.location_on_outlined, Icons.location_on, selected: true),
          label: NavLabels.tabLocations.forLang(lang),
        ),
        NavigationDestination(
          icon: _navIcon(Icons.apps_outlined, Icons.apps_rounded),
          selectedIcon: _navIcon(Icons.apps_outlined, Icons.apps_rounded, selected: true),
          label: NavLabels.tabMore.forLang(lang),
        ),
      ];

  List<NavigationRailDestination> _railDestinations(int cartCount, String lang) => [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: Text(NavLabels.tabHome.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.health_and_safety_outlined),
          selectedIcon: const Icon(Icons.health_and_safety),
          label: Text(NavLabels.tabServices.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            child: const Icon(Icons.shopping_bag),
          ),
          label: Text(NavLabels.tabShop.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.location_on_outlined),
          selectedIcon: const Icon(Icons.location_on),
          label: Text(NavLabels.tabLocations.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.apps_outlined),
          selectedIcon: const Icon(Icons.apps_rounded),
          label: Text(NavLabels.tabMore.forLang(lang)),
        ),
      ];

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required LanguageProvider lang,
    required int cartCount,
    required String currentPath,
  }) {
    final showBack = !RouteTitles.isTabRoot(currentPath);
    final title = RouteTitles.forPath(currentPath, lang.locale.languageCode);
    final code = lang.locale.languageCode;
    final onShop = currentPath.startsWith('/shop');

    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              tooltip: NavLabels.back.forLang(code),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                if (currentPath.startsWith('/shop')) {
                  context.go('/shop');
                } else if (currentPath.startsWith('/services')) {
                  context.go('/services');
                } else if (currentPath.startsWith('/locations')) {
                  context.go('/locations');
                } else if (currentPath.startsWith('/more')) {
                  context.go('/more');
                } else {
                  context.go('/home');
                }
              },
            )
          : null,
      titleSpacing: showBack ? 4 : 16,
      title: AppBarTitle(title),
      actions: [
        IconButton(
          tooltip: NavLabels.search.forLang(code),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SiteSearchDelegate(code),
            );
          },
          icon: const Icon(Icons.search_rounded, size: 22),
        ),
        if (onShop)
          IconButton(
            tooltip: NavLabels.orders.forLang(code),
            onPressed: () => context.push('/shop/orders'),
            icon: const Icon(Icons.receipt_long_outlined, size: 22),
          ),
        const LanguageChip(),
        IconButton(
          tooltip: NavLabels.cart.forLang(code),
          onPressed: () => context.push('/shop/cart'),
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
            child: const Icon(Icons.shopping_bag_outlined, size: 22),
          ),
        ),
        const SizedBox(width: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().cartCount;
    final lang = context.watch<LanguageProvider>();
    final useRail = context.useNavigationRail;
    final currentPath = GoRouterState.of(context).uri.path;
    final localeKey = lang.locale.languageCode;
    final selectedIndex = navigationShell.currentIndex;

    if (useRail) {
      return Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: _buildAppBar(
          context,
          lang: lang,
          cartCount: cartCount,
          currentPath: currentPath,
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                backgroundColor: AppColors.bgWhite,
                selectedIndex: selectedIndex,
                onDestinationSelected: _onTab,
                extended: context.useExtendedRail,
                labelType: context.useExtendedRail
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                minExtendedWidth: 88,
                useIndicator: true,
                indicatorColor: AppColors.primarySoft,
                destinations: _railDestinations(cartCount, localeKey),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: _buildAppBar(
        context,
        lang: lang,
        cartCount: cartCount,
        currentPath: currentPath,
      ),
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: _onTab,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 220),
          destinations: _phoneDestinations(cartCount, localeKey),
        ),
      ),
    );
  }
}
