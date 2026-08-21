import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../core/shop/order_utils.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../data/doctor_labels.dart';
import '../../../data/models/order.dart';
import '../../../data/models/portal.dart';
import '../../../data/portal_api.dart';
import '../../../data/portal_labels.dart';
import '../../../data/products.dart';
import '../../../data/shop_labels.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/portal_auth_provider.dart';
import '../../portal/portal_widgets.dart';

/// Logged-in home — appointment + order snapshot with quick actions.
class HomeDashboardSection extends StatefulWidget {
  const HomeDashboardSection({super.key});

  @override
  State<HomeDashboardSection> createState() => _HomeDashboardSectionState();
}

class _HomeDashboardSectionState extends State<HomeDashboardSection> {
  List<PortalAppointment> _appointments = const [];
  List<Order> _shopOrders = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!mounted) return;
    if (!context.read<PortalAuthProvider>().isAuthenticated) {
      setState(() => _loading = false);
      return;
    }

    List<PortalAppointment> appts = const [];
    List<Order> orders = const [];
    try {
      appts = (await PortalApi.listAppointments(filter: 'upcoming')).take(2).toList();
    } catch (_) {}
    try {
      orders = (await PortalApi.listOrders()).take(2).toList();
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(welcome, style: Theme.of(context).textTheme.headlineSmall),
          if (patient?.phone != null && patient!.phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              patient.phone,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PrimaryButton(
                label: PortalLabels.bookCta.forLang(lang),
                icon: Icons.calendar_month_rounded,
                onPressed: () => context.push('/more/book-appointment'),
              ),
              SecondaryButton(
                label: PortalLabels.viewAll.forLang(lang),
                icon: Icons.event_note_outlined,
                onPressed: () => context.push('/more/portal/appointments'),
              ),
                SecondaryButton(
                  label: PortalLabels.myOrders.forLang(lang),
                  icon: Icons.receipt_long_outlined,
                  onPressed: () => context.push('/shop/orders'),
                ),
                SecondaryButton(
                  label: PortalLabels.myProfile.forLang(lang),
                  icon: Icons.manage_accounts_outlined,
                  onPressed: () => context.push('/more/portal/profile'),
                ),
                SecondaryButton(
                  label: DoctorLabels.talkToDoctor.forLang(lang),
                  icon: Icons.phone_in_talk_outlined,
                  onPressed: () => context.go('/more/doctors'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          Text(PortalLabels.upcoming.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_appointments.isEmpty) ...[
            Text(PortalLabels.noUpcoming.forLang(lang)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: PrimaryButton(
                label: PortalLabels.bookCta.forLang(lang),
                icon: Icons.calendar_month_rounded,
                onPressed: () => context.push('/more/book-appointment'),
              ),
            ),
          ] else
            ..._appointments.map((a) => PortalAppointmentCard(appointment: a, lang: lang)),
          const SizedBox(height: 20),
          Text(PortalLabels.shopOrders.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          if (!_loading && _shopOrders.isEmpty)
            Text(PortalLabels.noOrders.forLang(lang))
          else if (!_loading)
            ..._shopOrders.map((order) => _OrderRow(order: order, lang: lang)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final Order order;
  final String lang;

  const _OrderRow({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    final count = order.items.length;
    final itemLabel = count == 1 ? ShopLabels.item(lang) : ShopLabels.items(lang);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(order.id, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${formatOrderDate(order.createdAt, lang)} · $count $itemLabel · ${formatPrice(order.totals.total)}',
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () => context.push('/shop/order-success/${order.id}'),
      ),
    );
  }
}
