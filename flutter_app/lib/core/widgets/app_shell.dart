import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/route_titles.dart';
import '../../config/theme.dart';
import '../../data/clinic.dart';
import '../../data/nav_labels.dart';
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

  List<NavigationDestination> _phoneDestinations(int cartCount, String lang) => [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: NavLabels.home.forLang(lang),
        ),
        NavigationDestination(
          icon: const Icon(Icons.medical_services_outlined),
          selectedIcon: const Icon(Icons.medical_services),
          label: NavLabels.services.forLang(lang),
        ),
        NavigationDestination(
          icon: Semantics(
            label: NavLabels.shop.forLang(lang),
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          selectedIcon: Semantics(
            label: NavLabels.shop.forLang(lang),
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
          ),
          label: NavLabels.shop.forLang(lang),
        ),
        NavigationDestination(
          icon: const Icon(Icons.location_on_outlined),
          selectedIcon: const Icon(Icons.location_on),
          label: NavLabels.locations.forLang(lang),
        ),
        NavigationDestination(
          icon: const Icon(Icons.menu),
          selectedIcon: const Icon(Icons.menu_open),
          label: NavLabels.more.forLang(lang),
        ),
      ];

  List<NavigationRailDestination> _railDestinations(int cartCount, String lang) => [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(NavLabels.home.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.medical_services_outlined),
          selectedIcon: const Icon(Icons.medical_services),
          label: Text(NavLabels.services.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: Semantics(
            label: NavLabels.shop.forLang(lang),
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          selectedIcon: Semantics(
            label: NavLabels.shop.forLang(lang),
            child: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag),
            ),
          ),
          label: Text(NavLabels.shop.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.location_on_outlined),
          selectedIcon: const Icon(Icons.location_on),
          label: Text(NavLabels.locations.forLang(lang)),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.menu),
          selectedIcon: const Icon(Icons.menu_open),
          label: Text(NavLabels.more.forLang(lang)),
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
    final code = lang.locale.languageCode;

    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
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
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          tooltip: NavLabels.search.forLang(code),
          onPressed: () {
            showSearch(
              context: context,
              delegate: SiteSearchDelegate(code),
            );
          },
          icon: const Icon(Icons.search),
        ),
        if (showQuickActions) ...[
          IconButton(
            tooltip: NavLabels.callClinic.forLang(code),
            onPressed: () async {
              final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            icon: const Icon(Icons.phone_outlined),
          ),
          IconButton(
            tooltip: NavLabels.bookAppointmentShort.forLang(code),
            onPressed: () => context.push('/more/book-appointment'),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
        IconButton(
          tooltip: lang.isSpanish ? NavLabels.english.forLang(code) : NavLabels.spanish.forLang(code),
          onPressed: () {
            // Defer so mouse-tracker is not mid-update when the tree rebuilds.
            WidgetsBinding.instance.addPostFrameCallback((_) => lang.toggle());
          },
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
            tooltip: NavLabels.cart.forLang(code),
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
    final localeKey = lang.locale.languageCode;

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
            lang: localeKey,
          ),
          SafeArea(
            top: false,
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTab,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              height: context.isCompactPhone ? 60 : 64,
              destinations: _phoneDestinations(cartCount, localeKey),
            ),
          ),
        ],
      ),
    );
  }
}
