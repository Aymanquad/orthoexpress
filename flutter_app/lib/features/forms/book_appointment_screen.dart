import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/forms/form_logic.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/form_result_dialog.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/form_labels.dart';
import '../../data/locations.dart';
import '../../data/page_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import '../../data/portal_labels.dart';
import '../portal/portal_login_screen.dart' show formatPortalPhone;

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _form = AppointmentFormData();
  final _errors = <String, String>{};
  bool _submitting = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
  }

  void _prefillFromProfile() {
    if (!mounted) return;
    final auth = context.read<PortalAuthProvider>();
    final patient = auth.patient;
    if (patient == null) return;

    final parts = [patient.firstName, patient.lastName]
        .where((s) => s != null && s.trim().isNotEmpty)
        .map((s) => s!.trim())
        .toList();
    if (parts.isNotEmpty) _nameController.text = parts.join(' ');
    if (patient.phone.isNotEmpty) {
      _phoneController.text = formatPortalPhone(patient.phone);
    }
    final email = patient.email?.trim() ?? '';
    if (email.isNotEmpty) _emailController.text = email;

    final preferred = auth.preferredLocationSlug;
    if (preferred != null &&
        preferred.isNotEmpty &&
        _form.location.isEmpty &&
        locations.any((l) => l.slug == preferred)) {
      _form.location = preferred;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _syncForm() {
    _form.name = _nameController.text;
    _form.phone = _phoneController.text;
    _form.email = _emailController.text;
    _form.reason = _reasonController.text;
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _reasonController.clear();
    _form.location = '';
    _form.preferredDate = '';
    _form.preferredTime = '';
    _form.consent = false;
  }

  Future<void> _submit(String lang) async {
    _syncForm();
    final validation = validateAppointmentForm(_form, lang);
    if (validation.isNotEmpty) {
      setState(() => _errors
        ..clear()
        ..addAll(validation));
      await showFormValidationDialog(
        context,
        title: BookLabels.checkForm(lang),
        errors: validation,
        primaryLabel: BookLabels.gotIt(lang),
      );
      return;
    }

    setState(() {
      _errors.clear();
      _submitting = true;
    });

    final result = await submitAppointmentForm(_form);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (!result.success) {
      await showFormDialog(
        context,
        type: FormDialogType.error,
        title: BookLabels.errorTitle(lang),
        message: result.errorMessage ?? BookLabels.checkForm(lang),
        primaryLabel: BookLabels.gotIt(lang),
      );
      return;
    }

    if (result.viaMailto) {
      final uri = Uri.parse(
        mailtoUri(
          appointmentMailtoSubject(_form),
          appointmentMailtoBody(_form),
        ),
      );
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    }

    if (!mounted) return;
    final wasSignedIn = context.read<PortalAuthProvider>().isAuthenticated;
    _clearForm();
    // Re-apply profile after clear so a second booking stays prefilled.
    _prefillFromProfile();
    setState(() {});
    await showFormDialog(
      context,
      type: FormDialogType.success,
      title: BookLabels.successTitle(lang),
      message: result.viaMailto
          ? BookLabels.successMailto(lang)
          : BookLabels.successForm(lang),
      primaryLabel: wasSignedIn
          ? PortalLabels.myAppointments.forLang(lang)
          : BookLabels.gotIt(lang),
      onPrimary: wasSignedIn
          ? () {
              if (context.mounted) context.go('/more/portal/appointments');
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final signedIn = context.watch<PortalAuthProvider>().isAuthenticated;
    final patient = context.watch<PortalAuthProvider>().patient;
    final info = _InfoSection(lang: lang);
    final form = _FormSection(
      lang: lang,
      form: _form,
      errors: _errors,
      submitting: _submitting,
      signedIn: signedIn,
      signedInPhone: patient?.phone ?? '',
      nameController: _nameController,
      phoneController: _phoneController,
      emailController: _emailController,
      reasonController: _reasonController,
      onLocationChanged: (v) {
        _errors.remove('location');
        setState(() => _form.location = v ?? '');
      },
      onDateChanged: (v) {
        _errors.remove('preferredDate');
        setState(() => _form.preferredDate = v);
      },
      onTimeChanged: (v) {
        setState(() => _form.preferredTime = v ?? '');
      },
      onConsentChanged: (v) {
        _errors.remove('consent');
        setState(() => _form.consent = v);
      },
      onFieldChanged: (field) => _errors.remove(field),
      onSubmit: () => _submit(lang),
    );

    return SingleChildScrollView(
      child: ResponsivePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              BookLabels.subtitle(lang),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
            const SizedBox(height: 24),
            if (context.isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: info),
                  const SizedBox(width: 24),
                  Expanded(flex: 3, child: form),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  info,
                  const SizedBox(height: 24),
                  form,
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String lang;

  const _InfoSection({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(BookLabels.formHint(lang), style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.access_time,
          title: AboutLabels.feature1Title.forLang(lang),
          text: AboutLabels.feature1Text.forLang(lang),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.calendar_month_outlined,
          title: BookLabels.preferredTime(lang),
          text: BookLabels.noPreference(lang),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(text, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String lang;
  final AppointmentFormData form;
  final Map<String, String> errors;
  final bool submitting;
  final bool signedIn;
  final String signedInPhone;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController reasonController;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String> onDateChanged;
  final ValueChanged<String?> onTimeChanged;
  final ValueChanged<bool> onConsentChanged;
  final ValueChanged<String> onFieldChanged;
  final VoidCallback onSubmit;

  const _FormSection({
    required this.lang,
    required this.form,
    required this.errors,
    required this.submitting,
    required this.signedIn,
    required this.signedInPhone,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.reasonController,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onConsentChanged,
    required this.onFieldChanged,
    required this.onSubmit,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      final value =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      onDateChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(BookLabels.formTitle(lang), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              BookLabels.formHint(lang),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            if (signedIn) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        signedInPhone.isEmpty
                            ? PortalLabels.signedInAs.forLang(lang)
                            : '${PortalLabels.signedInAs.forLang(lang)} · $signedInPhone',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              BookLabels.yourDetails(lang),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '${BookLabels.fullName(lang)} *',
                errorText: errors['name'],
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => onFieldChanged('name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              readOnly: signedIn && signedInPhone.isNotEmpty,
              decoration: InputDecoration(
                labelText: '${BookLabels.phone(lang)} *',
                errorText: errors['phone'],
                border: const OutlineInputBorder(),
                helperText: signedIn && signedInPhone.isNotEmpty
                    ? PortalLabels.signedInAs.forLang(lang)
                    : null,
              ),
              onChanged: (_) => onFieldChanged('phone'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '${BookLabels.email(lang)} *',
                errorText: errors['email'],
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => onFieldChanged('email'),
            ),
            const SizedBox(height: 20),
            Text(
              BookLabels.visitDetails(lang),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: form.location.isEmpty ? null : form.location,
              decoration: InputDecoration(
                labelText: '${BookLabels.location(lang)} *',
                errorText: errors['location'],
                border: const OutlineInputBorder(),
              ),
              items: locations
                  .map(
                    (loc) => DropdownMenuItem(
                      value: loc.slug,
                      child: Text(
                        '${loc.name} — ${loc.city}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) => locations
                  .map(
                    (loc) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        '${loc.name} — ${loc.city}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onLocationChanged,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _pickDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '${BookLabels.preferredDate(lang)} *',
                  errorText: errors['preferredDate'],
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  form.preferredDate.isEmpty
                      ? BookLabels.selectDate(lang)
                      : form.preferredDate,
                  style: form.preferredDate.isEmpty
                      ? TextStyle(color: AppColors.textMuted)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: form.preferredTime.isEmpty ? null : form.preferredTime,
              decoration: InputDecoration(
                labelText: BookLabels.preferredTime(lang),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: 'morning',
                  child: Text(
                    BookLabels.morning(lang),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                DropdownMenuItem(
                  value: 'afternoon',
                  child: Text(
                    BookLabels.afternoon(lang),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                DropdownMenuItem(
                  value: 'evening',
                  child: Text(
                    BookLabels.lateAfternoon(lang),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              selectedItemBuilder: (context) => [
                BookLabels.morning(lang),
                BookLabels.afternoon(lang),
                BookLabels.lateAfternoon(lang),
              ]
                  .map(
                    (label) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onTimeChanged,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: BookLabels.reason(lang),
                hintText: BookLabels.reasonPlaceholder(lang),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: form.consent,
              onChanged: (v) => onConsentChanged(v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${BookLabels.consent(lang)} '),
                  GestureDetector(
                    onTap: () => context.push('/more/privacy-policy'),
                    child: Text(
                      BookLabels.privacyPolicy(lang),
                      style: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text('.'),
                ],
              ),
              subtitle: errors['consent'] != null
                  ? Text(errors['consent']!, style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : null,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: submitting ? null : onSubmit,
              child: Text(submitting ? BookLabels.submitting(lang) : BookLabels.submit(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
