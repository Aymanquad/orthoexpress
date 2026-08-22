import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/models/workplace.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

const _roles = ['MANAGER', 'FRONT_DESK', 'CLINICAL', 'BILLING'];

class WorkplaceStaffScreen extends StatefulWidget {
  const WorkplaceStaffScreen({super.key});

  @override
  State<WorkplaceStaffScreen> createState() => _WorkplaceStaffScreenState();
}

class _WorkplaceStaffScreenState extends State<WorkplaceStaffScreen> {
  List<WorkplaceStaffMember> _staff = [];
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
      final list = await WorkplaceApi.listStaff();
      if (!mounted) return;
      setState(() {
        _staff = list;
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

  Future<void> _openEditor({WorkplaceStaffMember? existing}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _StaffEditorSheet(existing: existing),
    );
    if (result == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<WorkplaceAuthProvider>().isAdmin;
    if (!isAdmin) {
      return const Center(child: Text('Admin access required'));
    }

    return ResponsiveScrollPage(
      onRefresh: _load,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Staff', style: Theme.of(context).textTheme.displaySmall),
            ),
            FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Staff accounts linked to this practice admin.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red.shade700)),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_staff.isEmpty)
          const Text('No staff yet.')
        else
          ..._staff.map(
            (s) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(s.displayName),
                subtitle: Text(
                  '${s.email}\n${s.role.replaceAll('_', ' ')} · ${s.isActive ? 'Active' : 'Inactive'}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _openEditor(existing: s),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StaffEditorSheet extends StatefulWidget {
  final WorkplaceStaffMember? existing;
  const _StaffEditorSheet({this.existing});

  @override
  State<_StaffEditorSheet> createState() => _StaffEditorSheetState();
}

class _StaffEditorSheetState extends State<_StaffEditorSheet> {
  late final TextEditingController email;
  late final TextEditingController password;
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  late String role;
  late bool isActive;
  late bool apptRead;
  late bool apptWrite;
  late bool orderRead;
  late bool orderWrite;
  late bool rxRead;
  late bool rxWrite;
  late bool demoRead;
  late bool demoWrite;
  bool saving = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    email = TextEditingController(text: e?.email ?? '');
    password = TextEditingController();
    firstName = TextEditingController(text: e?.firstName ?? '');
    lastName = TextEditingController(text: e?.lastName ?? '');
    role = e?.role ?? 'FRONT_DESK';
    isActive = e?.isActive ?? true;
    apptRead = e?.permissions.appointments.read ?? true;
    apptWrite = e?.permissions.appointments.write ?? false;
    orderRead = e?.permissions.orders.read ?? false;
    orderWrite = e?.permissions.orders.write ?? false;
    rxRead = e?.permissions.prescriptions.read ?? false;
    rxWrite = e?.permissions.prescriptions.write ?? false;
    demoRead = e?.permissions.demographics.read ?? false;
    demoWrite = e?.permissions.demographics.write ?? false;
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      saving = true;
      error = '';
    });
    try {
      final payload = <String, dynamic>{
        'email': email.text.trim(),
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'role': role,
        'isActive': isActive,
        'permissions': {
          'appointments': {'read': apptRead || apptWrite, 'write': apptWrite},
          'orders': {'read': orderRead || orderWrite, 'write': orderWrite},
          'prescriptions': {'read': rxRead || rxWrite, 'write': rxWrite},
          'demographics': {'read': demoRead || demoWrite, 'write': demoWrite},
        },
      };
      if (widget.existing == null) {
        payload['password'] = password.text;
        await WorkplaceApi.createStaff(payload);
      } else {
        if (password.text.trim().isNotEmpty) payload['password'] = password.text;
        await WorkplaceApi.updateStaff(widget.existing!.id, payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existing == null ? 'Add staff' : 'Edit staff',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: widget.existing == null ? 'Password' : 'Password (optional)',
              ),
            ),
            TextField(controller: firstName, decoration: const InputDecoration(labelText: 'First name')),
            TextField(controller: lastName, decoration: const InputDecoration(labelText: 'Last name')),
            DropdownButtonFormField<String>(
              key: ValueKey(role),
              initialValue: role,
              items: _roles
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.replaceAll('_', ' '))))
                  .toList(),
              onChanged: (v) => setState(() => role = v ?? role),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Active'),
              value: isActive,
              onChanged: (v) => setState(() => isActive = v),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Appointments read'),
              value: apptRead || apptWrite,
              onChanged: (v) => setState(() => apptRead = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Appointments write'),
              value: apptWrite,
              onChanged: (v) => setState(() {
                apptWrite = v ?? false;
                if (apptWrite) apptRead = true;
              }),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Orders read'),
              value: orderRead || orderWrite,
              onChanged: (v) => setState(() => orderRead = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Orders write'),
              value: orderWrite,
              onChanged: (v) => setState(() {
                orderWrite = v ?? false;
                if (orderWrite) orderRead = true;
              }),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Prescriptions read'),
              value: rxRead || rxWrite,
              onChanged: (v) => setState(() => rxRead = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Prescriptions write'),
              value: rxWrite,
              onChanged: (v) => setState(() {
                rxWrite = v ?? false;
                if (rxWrite) rxRead = true;
              }),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Demographics read'),
              value: demoRead || demoWrite,
              onChanged: (v) => setState(() => demoRead = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Demographics write'),
              value: demoWrite,
              onChanged: (v) => setState(() {
                demoWrite = v ?? false;
                if (demoWrite) demoRead = true;
              }),
            ),
            if (error.isNotEmpty) Text(error, style: TextStyle(color: Colors.red.shade700)),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: saving ? null : _save,
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(saving ? 'Saving…' : 'Save'),
            ),
            if (widget.existing != null) ...[
              TextButton(
                onPressed: saving
                    ? null
                    : () async {
                        await WorkplaceApi.deactivateStaff(widget.existing!.id);
                        if (context.mounted) Navigator.of(context).pop(true);
                      },
                child: const Text('Deactivate'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
