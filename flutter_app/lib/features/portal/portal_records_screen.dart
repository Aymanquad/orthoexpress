import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/portal_api.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import 'portal_widgets.dart';

class PortalRecordsScreen extends StatefulWidget {
  const PortalRecordsScreen({super.key});

  @override
  State<PortalRecordsScreen> createState() => _PortalRecordsScreenState();
}

class _PortalRecordsScreenState extends State<PortalRecordsScreen> {
  List<Map<String, dynamic>> _rx = const [];
  Map<String, dynamic>? _demo;
  Map<String, dynamic>? _patient;
  String _rxFilter = 'ALL';
  bool _loading = true;
  bool _saving = false;
  bool _editing = false;
  String _error = '';
  String _success = '';

  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  final _country = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _emergencyRelationship = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    _country.dispose();
    _emergencyName.dispose();
    _emergencyPhone.dispose();
    _emergencyRelationship.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _hydrateContact(Map<String, dynamic>? demo) {
    _address.text = demo?['address'] as String? ?? '';
    _city.text = demo?['city'] as String? ?? '';
    _state.text = demo?['state'] as String? ?? '';
    _zip.text = demo?['zip'] as String? ?? '';
    _country.text = demo?['country'] as String? ?? '';
    _emergencyName.text = demo?['emergencyName'] as String? ?? '';
    _emergencyPhone.text = demo?['emergencyPhone'] as String? ?? '';
    _emergencyRelationship.text = demo?['emergencyRelationship'] as String? ?? '';
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final rx = await PortalApi.listPrescriptions();
      final demoRes = await PortalApi.getDemographics();
      if (!mounted) return;
      final demo = demoRes['demographics'] as Map<String, dynamic>?;
      setState(() {
        _rx = rx;
        _demo = demo;
        _patient = demoRes['patient'] as Map<String, dynamic>?;
        _loading = false;
      });
      _hydrateContact(demo);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = PortalLabels.genericError.forLang(context.read<LanguageProvider>().locale.languageCode);
      });
    }
  }

  Future<void> _saveContact(String lang) async {
    setState(() {
      _saving = true;
      _error = '';
      _success = '';
    });
    try {
      final res = await PortalApi.updateDemographicsContact({
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'state': _state.text.trim(),
        'zip': _zip.text.trim(),
        'country': _country.text.trim(),
        'emergencyName': _emergencyName.text.trim(),
        'emergencyPhone': _emergencyPhone.text.trim(),
        'emergencyRelationship': _emergencyRelationship.text.trim(),
      });
      if (!mounted) return;
      setState(() {
        _demo = res['demographics'] as Map<String, dynamic>?;
        _patient = res['patient'] as Map<String, dynamic>?;
        _editing = false;
        _saving = false;
        _success = PortalLabels.contactSaved.forLang(lang);
      });
      _hydrateContact(_demo);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = PortalLabels.genericError.forLang(lang);
      });
    }
  }

  int _rxCount(String filter) {
    if (filter == 'ALL') return _rx.length;
    if (filter == 'DISCONTINUED') {
      return _rx.where((r) {
        final s = '${r['status']}'.toUpperCase();
        return s == 'DISCONTINUED' || s == 'STOPPED';
      }).length;
    }
    return _rx.where((r) => '${r['status']}'.toUpperCase() == filter).length;
  }

  List<Map<String, dynamic>> get _filteredRx {
    if (_rxFilter == 'ALL') return _rx;
    if (_rxFilter == 'DISCONTINUED') {
      return _rx.where((r) {
        final s = '${r['status']}'.toUpperCase();
        return s == 'DISCONTINUED' || s == 'STOPPED';
      }).toList();
    }
    return _rx.where((r) => '${r['status']}'.toUpperCase() == _rxFilter).toList();
  }

  String? _formatUpdated(String? iso, String lang) {
    if (iso == null || iso.isEmpty) return null;
    final date = DateTime.tryParse(iso);
    if (date == null) return null;
    final locale = lang == 'es' ? 'es_US' : 'en_US';
    return DateFormat.yMMMd(locale).add_jm().format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final authPatient = context.watch<PortalAuthProvider>().patient;
    final firstName = authPatient?.displayFirstName ??
        _patient?['firstName'] as String? ??
        PortalLabels.welcomeGuest.forLang(lang);
    final displayName = [
      authPatient?.firstName ?? _patient?['firstName'],
      authPatient?.lastName ?? _patient?['lastName'],
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' ');
    final phone = authPatient?.phone ?? _patient?['phone'] as String? ?? '';
    final activeCount = _rx.where((r) => '${r['status']}'.toUpperCase() == 'ACTIVE').length;
    final updated = _formatUpdated(_demo?['updatedAt'] as String?, lang);

    return ResponsiveScrollPage(
      onRefresh: _load,
      padding: EdgeInsets.zero,
      children: [
        _RecordsHero(
          lang: lang,
          firstName: firstName,
          displayName: displayName.isEmpty ? firstName : displayName,
          phone: phone,
          activeCount: activeCount,
          hasAllergies: (_demo?['allergies'] as String?)?.trim().isNotEmpty == true,
          hasInsurance: (_demo?['insuranceProvider'] as String?)?.trim().isNotEmpty == true,
          updated: updated,
          onBack: () => context.push('/more/portal'),
        ),
        Padding(
          padding: context.pagePadding.copyWith(top: 16, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => context.push('/more/book-appointment'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: Text(PortalLabels.bookCta.forLang(lang)),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/more/contact-us'),
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: Text(PortalLabels.contactClinic.forLang(lang)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
                  if (!_editing)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _editing = true),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(PortalLabels.editContact.forLang(lang)),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_error.isNotEmpty)
                _AlertBanner(text: _error, error: true),
              if (_success.isNotEmpty)
                _AlertBanner(text: _success, error: false),
              if ((_demo?['allergies'] as String?)?.trim().isNotEmpty == true) ...[
                _AllergyBanner(
                  title: PortalLabels.allergyAlert.forLang(lang),
                  body: _demo!['allergies'] as String,
                ),
                const SizedBox(height: 12),
              ],
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                PortalRecordsCard(
                  icon: Icons.person_outline,
                  iconBg: AppColors.primarySoft,
                  iconColor: AppColors.primary,
                  title: PortalLabels.demographics.forLang(lang),
                  subtitle: PortalLabels.demographicsHint.forLang(lang),
                  child: _editing
                      ? _ContactForm(
                          lang: lang,
                          saving: _saving,
                          address: _address,
                          city: _city,
                          state: _state,
                          zip: _zip,
                          country: _country,
                          emergencyName: _emergencyName,
                          emergencyPhone: _emergencyPhone,
                          emergencyRelationship: _emergencyRelationship,
                          onSave: () => _saveContact(lang),
                          onCancel: () {
                            setState(() => _editing = false);
                            _hydrateContact(_demo);
                          },
                        )
                      : _DemographicsBody(demo: _demo, lang: lang),
                ),
                const SizedBox(height: 16),
                PortalRecordsCard(
                  icon: Icons.medication_outlined,
                  iconBg: const Color(0xFFECFDF5),
                  iconColor: AppColors.accent,
                  title: PortalLabels.prescriptions.forLang(lang),
                  subtitle: PortalLabels.prescriptionsHint.forLang(lang),
                  child: _rx.isEmpty
                      ? _EmptyBlock(text: PortalLabels.noRx.forLang(lang))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final key in ['ALL', 'ACTIVE', 'COMPLETED', 'DISCONTINUED'])
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        label: Text(
                                          '${_filterLabel(key, lang)} (${_rxCount(key)})',
                                        ),
                                        selected: _rxFilter == key,
                                        onSelected: (_) => setState(() => _rxFilter = key),
                                        selectedColor: Colors.white,
                                        checkmarkColor: AppColors.primary,
                                        side: BorderSide(
                                          color: _rxFilter == key ? AppColors.primary : AppColors.border,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (_filteredRx.isEmpty)
                              _EmptyBlock(text: PortalLabels.noRxFilter.forLang(lang), compact: true)
                            else
                              ..._filteredRx.map((rx) => PortalRxCard(rx: rx, lang: lang)),
                          ],
                        ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _filterLabel(String key, String lang) => switch (key) {
        'ALL' => PortalLabels.filterAll.forLang(lang),
        'ACTIVE' => PortalLabels.rxStatus('ACTIVE', lang),
        'COMPLETED' => PortalLabels.rxStatus('COMPLETED', lang),
        _ => PortalLabels.rxStatus('DISCONTINUED', lang),
      };
}

class _RecordsHero extends StatelessWidget {
  final String lang;
  final String firstName;
  final String displayName;
  final String phone;
  final int activeCount;
  final bool hasAllergies;
  final bool hasInsurance;
  final String? updated;
  final VoidCallback onBack;

  const _RecordsHero({
    required this.lang,
    required this.firstName,
    required this.displayName,
    required this.phone,
    required this.activeCount,
    required this.hasAllergies,
    required this.hasInsurance,
    required this.updated,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8EEF9), Color(0xFFECFDF5), Colors.white],
        ),
        border: Border(bottom: BorderSide(color: Color(0x141A237E))),
      ),
      child: ResponsivePage(
        padding: context.pagePadding.copyWith(top: 12, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(PortalLabels.goToDashboard.forLang(lang)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'MY PORTAL',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              PortalLabels.recordsHeroTitle(lang, firstName),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              PortalLabels.recordsLead.forLang(lang),
              style: const TextStyle(color: AppColors.textLight, height: 1.55, fontSize: 15),
            ),
            if (updated != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0x141A237E)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 14, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    Text(
                      '${PortalLabels.lastUpdated.forLang(lang)}: $updated',
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF34D399), AppColors.accent],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName, style: Theme.of(context).textTheme.titleMedium),
                            Text(phone, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          value: '$activeCount',
                          label: PortalLabels.activeRx.forLang(lang),
                          tone: _MetricTone.rx,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricTile(
                          value: hasAllergies ? '!' : '—',
                          label: PortalLabels.allergies.forLang(lang),
                          tone: hasAllergies ? _MetricTone.alert : _MetricTone.neutral,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MetricTile(
                          value: hasInsurance ? '✓' : '—',
                          label: PortalLabels.insurance.forLang(lang),
                          tone: hasInsurance ? _MetricTone.ok : _MetricTone.neutral,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _MetricTone { rx, alert, ok, neutral }

class _MetricTile extends StatelessWidget {
  final String value;
  final String label;
  final _MetricTone tone;

  const _MetricTile({required this.value, required this.label, required this.tone});

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      _MetricTone.rx => (const Color(0xFFEFF6FF), const Color(0xFF0284C7)),
      _MetricTone.alert => (const Color(0xFFFFF7ED), const Color(0xFFC2410C)),
      _MetricTone.ok => (const Color(0xFFECFDF5), AppColors.accent),
      _MetricTone.neutral => (const Color(0xFFF8FAFC), AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.$2),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class _DemographicsBody extends StatelessWidget {
  final Map<String, dynamic>? demo;
  final String lang;

  const _DemographicsBody({required this.demo, required this.lang});

  String _join(List<String?> parts) => parts.whereType<String>().where((s) => s.trim().isNotEmpty).join(', ');

  @override
  Widget build(BuildContext context) {
    if (demo == null) {
      return _EmptyBlock(text: PortalLabels.noDemo.forLang(lang));
    }

    final address = _join([
      demo!['address'] as String?,
      demo!['city'] as String?,
      demo!['state'] as String?,
      demo!['zip'] as String?,
      demo!['country'] as String?,
    ]);
    final emergency = [
      demo!['emergencyName'],
      demo!['emergencyRelationship'],
      demo!['emergencyPhone'],
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' · ');
    final insurance = [
      demo!['insuranceProvider'],
      demo!['insurancePolicyNumber'],
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' · ');

    Widget section(String title, List<Widget> tiles) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: tiles),
          const SizedBox(height: 14),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        section(PortalLabels.sectionIdentity.forLang(lang), [
          PortalInfoTile(
            icon: Icons.calendar_today_outlined,
            label: PortalLabels.dob.forLang(lang),
            value: demo!['dateOfBirth'] as String?,
          ),
          PortalInfoTile(
            icon: Icons.person_outline,
            label: PortalLabels.sex.forLang(lang),
            value: demo!['sex'] as String?,
          ),
          if ((demo!['bloodType'] as String?)?.trim().isNotEmpty == true)
            PortalInfoTile(
              icon: Icons.water_drop_outlined,
              label: PortalLabels.bloodType.forLang(lang),
              value: demo!['bloodType'] as String?,
            ),
        ]),
        section(PortalLabels.sectionContact.forLang(lang), [
          PortalInfoTile(icon: Icons.location_on_outlined, label: PortalLabels.address.forLang(lang), value: address, wide: true),
          PortalInfoTile(icon: Icons.phone_outlined, label: PortalLabels.emergency.forLang(lang), value: emergency, wide: true),
        ]),
        if (insurance.isNotEmpty)
          section(PortalLabels.sectionCoverage.forLang(lang), [
            PortalInfoTile(icon: Icons.shield_outlined, label: PortalLabels.insurance.forLang(lang), value: insurance, wide: true),
          ]),
        section(PortalLabels.sectionClinical.forLang(lang), [
          PortalInfoTile(
            icon: Icons.favorite_outline,
            label: PortalLabels.allergies.forLang(lang),
            value: demo!['allergies'] as String?,
            warn: (demo!['allergies'] as String?)?.trim().isNotEmpty == true,
          ),
          PortalInfoTile(
            icon: Icons.assignment_outlined,
            label: PortalLabels.conditions.forLang(lang),
            value: demo!['conditions'] as String?,
          ),
        ]),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            PortalLabels.clinicalReadOnly.forLang(lang),
            style: const TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.45),
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  final String lang;
  final bool saving;
  final TextEditingController address;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController zip;
  final TextEditingController country;
  final TextEditingController emergencyName;
  final TextEditingController emergencyPhone;
  final TextEditingController emergencyRelationship;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _ContactForm({
    required this.lang,
    required this.saving,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyRelationship,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          PortalLabels.contactEditHint.forLang(lang),
          style: const TextStyle(color: AppColors.textLight, height: 1.45),
        ),
        const SizedBox(height: 14),
        TextField(controller: address, decoration: InputDecoration(labelText: PortalLabels.address.forLang(lang))),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextField(controller: city, decoration: const InputDecoration(labelText: 'City'))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: state, decoration: const InputDecoration(labelText: 'State'))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TextField(controller: zip, decoration: const InputDecoration(labelText: 'ZIP'))),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: country,
                decoration: InputDecoration(labelText: PortalLabels.country.forLang(lang)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: emergencyName,
                decoration: InputDecoration(labelText: PortalLabels.emergency.forLang(lang)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: emergencyPhone,
                decoration: InputDecoration(labelText: PortalLabels.emergencyPhone.forLang(lang)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: emergencyRelationship,
          decoration: InputDecoration(labelText: PortalLabels.emergencyRelationship.forLang(lang)),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: saving ? null : onSave,
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(saving ? PortalLabels.savingContact.forLang(lang) : PortalLabels.saveContact.forLang(lang)),
            ),
            OutlinedButton(onPressed: saving ? null : onCancel, child: Text(PortalLabels.cancel.forLang(lang))),
          ],
        ),
      ],
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final String text;
  final bool error;

  const _AlertBanner({required this.text, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: error ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: error ? const Color(0xFFFECACA) : const Color(0xFFA7F3D0)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: error ? const Color(0xFFB91C1C) : const Color(0xFF047857),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AllergyBanner extends StatelessWidget {
  final String title;
  final String body;

  const _AllergyBanner({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFEF3C7)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDBA74)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF9A3412)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF9A3412))),
                const SizedBox(height: 2),
                Text(body, style: const TextStyle(color: Color(0xFF9A3412), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBlock extends StatelessWidget {
  final String text;
  final bool compact;

  const _EmptyBlock({required this.text, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: compact ? 16 : 28, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textLight)),
    );
  }
}
