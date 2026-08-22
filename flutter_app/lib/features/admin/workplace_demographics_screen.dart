import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/models/workplace.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

class WorkplaceDemographicsScreen extends StatefulWidget {
  const WorkplaceDemographicsScreen({super.key});

  @override
  State<WorkplaceDemographicsScreen> createState() => _WorkplaceDemographicsScreenState();
}

class _WorkplaceDemographicsScreenState extends State<WorkplaceDemographicsScreen> {
  List<WorkplacePatient> _patients = [];
  bool _loading = true;
  String _error = '';

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
      final list = await WorkplaceApi.listDemographics();
      if (!mounted) return;
      setState(() {
        _patients = list;
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

  Future<void> _edit(WorkplacePatient row) async {
    final canWrite = context.read<WorkplaceAuthProvider>().can('demographics', access: 'write');
    final demo = row.demographics ?? {};
    final address = TextEditingController(text: demo['address'] as String? ?? '');
    final emergencyName = TextEditingController(text: demo['emergencyName'] as String? ?? '');
    final emergencyPhone = TextEditingController(text: demo['emergencyPhone'] as String? ?? '');
    final emergencyRelationship = TextEditingController(text: demo['emergencyRelationship'] as String? ?? '');
    final insuranceProvider = TextEditingController(text: demo['insuranceProvider'] as String? ?? '');
    final insurancePolicyNumber = TextEditingController(text: demo['insurancePolicyNumber'] as String? ?? '');
    final allergies = TextEditingController(text: demo['allergies'] as String? ?? '');
    final conditions = TextEditingController(text: demo['conditions'] as String? ?? '');
    final bloodType = TextEditingController(text: demo['bloodType'] as String? ?? '');
    final updatedBy = demo['updatedByName'] as String?;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(row.displayName),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.phone, style: Theme.of(context).textTheme.bodySmall),
                if (updatedBy != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Text(
                      'Last updated by $updatedBy',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                TextField(
                  controller: address,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: emergencyName,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Emergency contact'),
                ),
                TextField(
                  controller: emergencyPhone,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Emergency phone'),
                ),
                TextField(
                  controller: emergencyRelationship,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                ),
                TextField(
                  controller: insuranceProvider,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Insurance provider'),
                ),
                TextField(
                  controller: insurancePolicyNumber,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Policy / member #'),
                ),
                TextField(
                  controller: bloodType,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Blood type'),
                ),
                TextField(
                  controller: allergies,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Allergies'),
                ),
                TextField(
                  controller: conditions,
                  enabled: canWrite,
                  decoration: const InputDecoration(labelText: 'Conditions'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Close')),
          if (canWrite)
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true && canWrite) {
      await WorkplaceApi.updateDemographics(row.id, {
        'address': address.text.trim(),
        'emergencyName': emergencyName.text.trim(),
        'emergencyPhone': emergencyPhone.text.trim(),
        'emergencyRelationship': emergencyRelationship.text.trim(),
        'insuranceProvider': insuranceProvider.text.trim(),
        'insurancePolicyNumber': insurancePolicyNumber.text.trim(),
        'bloodType': bloodType.text.trim(),
        'allergies': allergies.text.trim(),
        'conditions': conditions.text.trim(),
      });
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollPage(
      onRefresh: _load,
      children: [
        Text('Demographics', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        Text(
          'Patient contact and clinical background on file.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red.shade700)),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_patients.isEmpty)
          const Text('No patients found.')
        else
          ..._patients.map(
            (p) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primarySoft,
                  child: Text(p.displayName.isNotEmpty ? p.displayName[0].toUpperCase() : '?'),
                ),
                title: Text(p.displayName),
                subtitle: Text(p.phone),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _edit(p),
              ),
            ),
          ),
      ],
    );
  }
}
