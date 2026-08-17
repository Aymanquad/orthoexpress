import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/models/portal.dart';
import '../../data/portal_api.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import 'portal_widgets.dart';

class PortalAppointmentsScreen extends StatefulWidget {
  const PortalAppointmentsScreen({super.key});

  @override
  State<PortalAppointmentsScreen> createState() => _PortalAppointmentsScreenState();
}

class _PortalAppointmentsScreenState extends State<PortalAppointmentsScreen> {
  String _filter = 'upcoming';
  List<PortalAppointment> _appointments = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await PortalApi.listAppointments(filter: _filter);
      if (!mounted) return;
      setState(() {
        _appointments = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _appointments = const [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final tabs = [
      ('upcoming', PortalLabels.tabUpcoming.forLang(lang)),
      ('past', PortalLabels.tabPast.forLang(lang)),
      ('all', PortalLabels.tabAll.forLang(lang)),
    ];

    return ContentPageScaffold(
      title: PortalLabels.appointmentsTitle.forLang(lang),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: () => context.go('/more/portal'),
            child: Text('← ${PortalLabels.myPortal.forLang(lang)}'),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tabs.map((tab) {
            final selected = _filter == tab.$1;
            return ChoiceChip(
              label: Text(tab.$2),
              selected: selected,
              onSelected: (_) {
                if (_filter == tab.$1) return;
                setState(() => _filter = tab.$1);
                _load();
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_appointments.isEmpty) ...[
          Text(PortalLabels.empty.forLang(lang)),
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
          ..._appointments.map(
            (appt) => PortalAppointmentCard(appointment: appt, lang: lang, showReason: true),
          ),
      ],
    );
  }
}
