import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/route_titles.dart';
import '../../config/theme.dart';
import '../../data/clinic.dart';
import '../../features/search/site_search.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../utils/responsive.dart';
import 'quick_action_bar.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  void _onTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  List<NavigationDestination> _phoneDestinations(int cartCount) => [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.medical_services_outlined),
          selectedIcon: Icon(Icons.medical_services),
          label: 'Services',
        ),
        NavigationDestination(
          icon: Semantics(
            label: 'Shop tab',
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          selectedIcon: Semantics(
            label: 'Shop tab',
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
          ),
          label: 'Shop',
        ),
        const NavigationDestination(
          icon: Icon(Icons.location_on_outlined),
          selectedIcon: Icon(Icons.location_on),
          label: 'Locations',
        ),
        const NavigationDestination(
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu_open),
          label: 'More',
        ),
      ];

  List<NavigationRailDestination> _railDestinations(int cartCount) => [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.medical_services_outlined),
          selectedIcon: Icon(Icons.medical_services),
          label: Text('Services'),
        ),
        NavigationRailDestination(
          icon: Semantics(
            label: 'Shop tab',
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          selectedIcon: Semantics(
            label: 'Shop tab',
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
          ),
          label: const Text('Shop'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.location_on_outlined),
          selectedIcon: Icon(Icons.location_on),
          label: Text('Locations'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu_open),
          label: Text('More'),
        ),
      ];

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required LanguageProvider lang,
    required int cartCount,
    required bool showQuickActions,
    required String currentPath,
  }) {
    final showBack = !RouteTitles.isTabRoot(currentPath);
    final title = RouteTitles.forPath(currentPath, lang.locale.languageCode);

    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          tooltip: lang.isSpanish ? 'Buscar' : 'Search',
          onPressed: () {
            showSearch(
              context: context,
              delegate: SiteSearchDelegate(lang.locale.languageCode),
            );
          },
          icon: const Icon(Icons.search),
        ),
        if (showQuickActions) ...[
          IconButton(
            tooltip: 'Call clinic',
            onPressed: () async {
              final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            icon: const Icon(Icons.phone_outlined),
          ),
          IconButton(
            tooltip: 'Book appointment',
            onPressed: () => context.push('/more/book-appointment'),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
        IconButton(
          tooltip: lang.isSpanish ? 'English' : 'Español',
          onPressed: () => lang.toggle(),
          icon: Text(
            lang.isSpanish ? 'EN' : 'ES',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        if (navigationShell.currentIndex == 2 || cartCount > 0)
          IconButton(
            tooltip: 'Cart',
            onPressed: () => context.push('/shop/cart'),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().cartCount;
    final lang = context.watch<LanguageProvider>();
    final useRail = context.useNavigationRail;
    final currentPath = GoRouterState.of(context).uri.path;

    if (useRail) {
      return Scaffold(
        appBar: _buildAppBar(
          context,
          lang: lang,
          cartCount: cartCount,
          showQuickActions: true,
          currentPath: currentPath,
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onTab,
                extended: context.useExtendedRail,
                labelType: context.useExtendedRail
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.selected,
                minExtendedWidth: 88,
                destinations: _railDestinations(cartCount),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(
        context,
        lang: lang,
        cartCount: cartCount,
        showQuickActions: false,
        currentPath: currentPath,
      ),
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuickActionBar(
            onBook: () => context.push('/more/book-appointment'),
            compact: context.isCompactPhone,
          ),
          SafeArea(
            top: false,
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTab,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              height: context.isCompactPhone ? 60 : 64,
              destinations: _phoneDestinations(cartCount),
            ),
          ),
        ],
      ),
    );
  }
}
