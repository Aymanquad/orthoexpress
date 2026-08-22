import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/models/workplace.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

class WorkplacePrescriptionsScreen extends StatefulWidget {
  const WorkplacePrescriptionsScreen({super.key});

  @override
  State<WorkplacePrescriptionsScreen> createState() => _WorkplacePrescriptionsScreenState();
}

class _WorkplacePrescriptionsScreenState extends State<WorkplacePrescriptionsScreen> {
  List<WorkplacePrescription> _rows = [];
  List<WorkplacePatient> _patients = [];
  bool _loading = true;
  String _error = '';
  String _status = 'ACTIVE';

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
      final rows = await WorkplaceApi.listPrescriptions(
        status: _status == 'ALL' ? null : _status,
      );
      List<WorkplacePatient> patients = const [];
      try {
        patients = await WorkplaceApi.listPatients();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _patients = patients;
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

  Future<void> _add() async {
    if (_patients.isEmpty) return;
    final patient = _patients.first;
    final med = TextEditingController();
    final dose = TextEditingController();
    String patientId = patient.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New prescription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: patientId,
              items: _patients
                  .map((p) => DropdownMenuItem(value: p.id, child: Text(p.displayName)))
                  .toList(),
              onChanged: (v) => patientId = v ?? patientId,
              decoration: const InputDecoration(labelText: 'Patient'),
            ),
            TextField(controller: med, decoration: const InputDecoration(labelText: 'Medication')),
            TextField(controller: dose, decoration: const InputDecoration(labelText: 'Dosage')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true || med.text.trim().isEmpty) return;
    await WorkplaceApi.createPrescription({
      'patientId': patientId,
      'medication': med.text.trim(),
      'dosage': dose.text.trim().isEmpty ? 'As directed' : dose.text.trim(),
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.watch<WorkplaceAuthProvider>().can('prescriptions', access: 'write');
    return ResponsiveScrollPage(
      onRefresh: _load,
      children: [
        Row(
          children: [
            Expanded(child: Text('Prescriptions', style: Theme.of(context).textTheme.displaySmall)),
            if (canWrite)
              IconButton(onPressed: _add, icon: const Icon(Icons.add_circle_outline)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: _status,
          items: const [
            DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
            DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
            DropdownMenuItem(value: 'DISCONTINUED', child: Text('Discontinued')),
            DropdownMenuItem(value: 'ALL', child: Text('All')),
          ],
          onChanged: (v) {
            setState(() => _status = v ?? 'ACTIVE');
            _load();
          },
        ),
        if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red.shade700)),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_rows.isEmpty)
          const Text('No prescriptions found.')
        else
          ..._rows.map(
            (rx) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primarySoft,
                  child: Text((rx.patientName ?? '?').isNotEmpty ? (rx.patientName ?? '?')[0].toUpperCase() : '?'),
                ),
                title: Text(rx.medication),
                subtitle: Text('${rx.patientName ?? rx.patientPhone ?? 'Patient'}\n${rx.dosage}'),
                isThreeLine: true,
                trailing: Text(rx.status.replaceAll('_', ' ')),
              ),
            ),
          ),
      ],
    );
  }
}
