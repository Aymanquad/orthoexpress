import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/shop/order_utils.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/models/order.dart';
import '../../data/models/portal.dart';
import '../../data/portal_api.dart';
import '../../data/portal_labels.dart';
import '../../data/products.dart';
import '../../data/shop_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import 'portal_widgets.dart';
import 'portal_login_screen.dart' show confirmSignOut;

class PortalDashboardScreen extends StatefulWidget {
  const PortalDashboardScreen({super.key});

  @override
  State<PortalDashboardScreen> createState() => _PortalDashboardScreenState();
}

class _PortalDashboardScreenState extends State<PortalDashboardScreen> {
  List<PortalAppointment> _appointments = const [];
  List<Order> _shopOrders = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!context.read<PortalAuthProvider>().isAuthenticated) {
        setState(() => _loading = false);
        return;
      }
      _load();
    });
  }

  Future<void> _load() async {
    List<PortalAppointment> appts = const [];
    List<Order> orders = const [];
    try {
      appts = (await PortalApi.listAppointments(filter: 'upcoming')).take(3).toList();
    } catch (_) {}
    try {
      orders = (await PortalApi.listOrders()).take(3).toList();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _appointments = appts;
      _shopOrders = orders;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final patient = context.watch<PortalAuthProvider>().patient;
    final firstName = patient?.displayFirstName ?? '';
    final welcome = firstName.isEmpty
        ? PortalLabels.welcomeGuest.forLang(lang)
        : PortalLabels.welcome(lang, firstName);

    return ContentPageScaffold(
      title: welcome,
      lead: patient?.phone,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => context.push('/more/book-appointment'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(PortalLabels.bookCta.forLang(lang)),
            ),
            OutlinedButton(
              onPressed: () => context.push('/more/portal/appointments'),
              child: Text(PortalLabels.viewAll.forLang(lang)),
            ),
            OutlinedButton(
              onPressed: () => context.push('/shop/orders'),
              child: Text(PortalLabels.myOrders.forLang(lang)),
            ),
            OutlinedButton(
              onPressed: () => context.push('/more/portal/records'),
              child: Text(PortalLabels.myRecords.forLang(lang)),
            ),
            OutlinedButton(
              onPressed: () => context.push('/more/contact-us'),
              child: Text(PortalLabels.contactClinic.forLang(lang)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(PortalLabels.upcoming.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_appointments.isEmpty) ...[
          Text(PortalLabels.noUpcoming.forLang(lang)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => context.push('/more/book-appointment'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(PortalLabels.bookCta.forLang(lang)),
            ),
          ),
        ] else
          ..._appointments.map((appt) => PortalAppointmentCard(appointment: appt, lang: lang)),
        const SizedBox(height: 24),
        Text(PortalLabels.shopOrders.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (!_loading && _shopOrders.isEmpty) ...[
          Text(PortalLabels.noOrders.forLang(lang)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () => context.go('/shop'),
              child: Text(ShopLabels.browseShop(lang)),
            ),
          ),
        ] else if (!_loading)
          ..._shopOrders.map((order) => _ShopOrderCard(order: order, lang: lang)),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            final lang = context.read<LanguageProvider>().locale.languageCode;
            final ok = await confirmSignOut(context, lang);
            if (!ok || !context.mounted) return;
            await context.read<PortalAuthProvider>().logout();
            if (!context.mounted) return;
            context.go('/home');
          },
          child: Text(PortalLabels.signOut.forLang(lang)),
        ),
      ],
    );
  }
}

class _ShopOrderCard extends StatelessWidget {
  final Order order;
  final String lang;

  const _ShopOrderCard({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    final count = order.items.length;
    final itemLabel = count == 1 ? ShopLabels.item(lang) : ShopLabels.items(lang);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    formatOrderDate(order.createdAt, lang),
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                  Text('$count $itemLabel · ${formatPrice(order.totals.total)}'),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => context.push('/shop/order-success/${order.id}'),
              child: Text(ShopLabels.viewReceipt(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
