import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/models/workplace.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

const _statuses = ['REQUESTED', 'SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW'];

class WorkplaceAppointmentsScreen extends StatefulWidget {
  const WorkplaceAppointmentsScreen({super.key});

  @override
  State<WorkplaceAppointmentsScreen> createState() => _WorkplaceAppointmentsScreenState();
}

class _WorkplaceAppointmentsScreenState extends State<WorkplaceAppointmentsScreen> {
  List<WorkplaceAppointment> _rows = [];
  bool _loading = true;
  String _error = '';
  String _filter = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final list = await WorkplaceApi.listAppointments(status: _filter.isEmpty ? null : _filter);
      if (!mounted) return;
      setState(() {
        _rows = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.watch<WorkplaceAuthProvider>().can('appointments', access: 'write');

    return ResponsiveScrollPage(
      onRefresh: _load,
      children: [
        Text('Appointments', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey('filter-$_filter'),
          initialValue: _filter,
          decoration: const InputDecoration(labelText: 'Status filter'),
          items: [
            const DropdownMenuItem(value: '', child: Text('All')),
            ..._statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))),
          ],
          onChanged: (v) {
            setState(() => _filter = v ?? '');
            _load();
          },
        ),
        const SizedBox(height: 12),
        if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red.shade700)),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_rows.isEmpty)
          const Text('No appointments found.')
        else
          ..._rows.map((a) {
            final when = a.scheduledAt ?? a.preferredAt ?? '—';
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.patientName ?? a.patientPhone ?? 'Patient',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text('${a.serviceName} · ${a.locationName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                    Text(when, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted)),
                    if (canWrite) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        key: ValueKey('${a.id}-${a.status}'),
                        initialValue: a.status,
                        decoration: const InputDecoration(labelText: 'Status', isDense: true),
                        items: _statuses
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) async {
                          if (v == null) return;
                          await WorkplaceApi.updateAppointment(a.id, {'status': v});
                          await _load();
                        },
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(a.status, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
