import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

class WorkplaceDashboardScreen extends StatefulWidget {
  const WorkplaceDashboardScreen({super.key});

  @override
  State<WorkplaceDashboardScreen> createState() => _WorkplaceDashboardScreenState();
}

class _WorkplaceDashboardScreenState extends State<WorkplaceDashboardScreen> {
  int staffCount = 0;
  int appointmentCount = 0;
  int orderCount = 0;
  int rxCount = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final auth = context.read<WorkplaceAuthProvider>();
    try {
      final futures = <Future>[];
      if (auth.isAdmin) {
        futures.add(WorkplaceApi.listStaff().then((v) => staffCount = v.where((s) => s.isActive).length));
      }
      if (auth.can('appointments')) {
        futures.add(WorkplaceApi.listAppointments().then((v) => appointmentCount = v.length));
      }
      if (auth.can('orders')) {
        futures.add(WorkplaceApi.listOrders().then((v) => orderCount = v.length));
      }
      if (auth.can('prescriptions')) {
        futures.add(WorkplaceApi.listPrescriptions(status: 'ACTIVE').then((v) => rxCount = v.length));
      }
      await Future.wait(futures);
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<WorkplaceAuthProvider>();
    final user = auth.user;

    return ResponsiveScrollPage(
      onRefresh: () async {
        setState(() => loading = true);
        await _load();
      },
      children: [
        Text('Workplace', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 4),
        Text(
          user == null
              ? ''
              : '${user.displayName} · ${auth.isAdmin ? 'Admin' : (user.role ?? 'Staff')}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 18),
        if (loading)
          const Center(child: CircularProgressIndicator())
        else ...[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (auth.isAdmin) _StatChip(label: 'Active staff', value: '$staffCount'),
              if (auth.can('appointments'))
                _StatChip(label: 'Appointments', value: '$appointmentCount'),
              if (auth.can('orders'))
                _StatChip(label: 'Orders', value: '$orderCount'),
              if (auth.can('prescriptions'))
                _StatChip(label: 'Rx', value: '$rxCount'),
            ],
          ),
          const SizedBox(height: 20),
          if (auth.isAdmin)
            _NavTile(
              title: 'Manage staff',
              subtitle: 'Create, edit, and set permissions',
              icon: Icons.groups_outlined,
              onTap: () => context.push('/more/admin/staff'),
            ),
          if (auth.can('appointments'))
            _NavTile(
              title: 'Appointments',
              subtitle: 'Review and update visit status',
              icon: Icons.event_note_outlined,
              onTap: () => context.push(user?.workplacePath('appointments') ?? '/more/admin/appointments'),
            ),
          if (auth.can('orders'))
            _NavTile(
              title: 'Shop orders',
              subtitle: 'Review and update order status',
              icon: Icons.receipt_long_outlined,
              onTap: () => context.push(user?.workplacePath('orders') ?? '/more/admin/orders'),
            ),
          if (auth.can('prescriptions'))
            _NavTile(
              title: 'Prescriptions',
              subtitle: 'Medications on file',
              icon: Icons.medication_outlined,
              onTap: () => context.push(user?.workplacePath('prescriptions') ?? '/more/admin/prescriptions'),
            ),
          if (auth.can('demographics'))
            _NavTile(
              title: 'Demographics',
              subtitle: 'Patient records',
              icon: Icons.badge_outlined,
              onTap: () => context.push(user?.workplacePath('demographics') ?? '/more/admin/demographics'),
            ),
        ],
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            await context.read<WorkplaceAuthProvider>().logout();
            if (context.mounted) context.go('/more');
          },
          child: const Text('Sign out of workplace'),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
