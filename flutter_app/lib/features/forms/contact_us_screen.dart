import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/forms/form_logic.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/form_result_dialog.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';
import '../../data/form_labels.dart';
import '../../providers/language_provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _form = ContactFormData();
  final _errors = <String, String>{};
  bool _submitting = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _syncForm() {
    _form.name = _nameController.text;
    _form.email = _emailController.text;
    _form.phone = _phoneController.text;
    _form.message = _messageController.text;
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
    _form.consent = false;
  }

  Future<void> _submit(String lang) async {
    _syncForm();
    final validation = validateContactForm(_form, lang);
    if (validation.isNotEmpty) {
      setState(() => _errors
        ..clear()
        ..addAll(validation));
      await showFormValidationDialog(
        context,
        title: ContactLabels.checkForm(lang),
        errors: validation,
        primaryLabel: ContactLabels.gotIt(lang),
      );
      return;
    }

    setState(() {
      _errors.clear();
      _submitting = true;
    });

    final result = await submitContactForm(_form);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (!result.success) {
      await showFormDialog(
        context,
        type: FormDialogType.error,
        title: ContactLabels.errorTitle(lang),
        message: result.errorMessage ?? ContactLabels.errorMessage(lang),
        primaryLabel: ContactLabels.gotIt(lang),
      );
      return;
    }

    if (result.viaMailto) {
      final uri = Uri.parse(
        mailtoUri(
          contactMailtoSubject(_form),
          contactMailtoBody(_form),
        ),
      );
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    }

    if (!mounted) return;
    _clearForm();
    setState(() {});
    await showFormDialog(
      context,
      type: FormDialogType.success,
      title: ContactLabels.successTitle(lang),
      message: result.viaMailto
          ? ContactLabels.successMailto(lang)
          : ContactLabels.successForm(lang),
      primaryLabel: ContactLabels.gotIt(lang),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final info = _ContactInfo(lang: lang);
    final form = _ContactForm(
      lang: lang,
      form: _form,
      errors: _errors,
      submitting: _submitting,
      nameController: _nameController,
      emailController: _emailController,
      phoneController: _phoneController,
      messageController: _messageController,
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
              ContactLabels.subtitle(lang),
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

class _ContactInfo extends StatelessWidget {
  final String lang;

  const _ContactInfo({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ContactLabels.getInTouch(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(ContactLabels.getInTouchText(lang)),
        const SizedBox(height: 20),
        _DetailTile(
          icon: Icons.phone_outlined,
          title: ContactLabels.phone(lang),
          child: GestureDetector(
            onTap: () async {
              final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            child: Text(
              ClinicData.headquartersPhone,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          footer: Text('${ContactLabels.fax(lang)}: ${ClinicData.headquartersFax}'),
        ),
        _DetailTile(
          icon: Icons.email_outlined,
          title: ContactLabels.email(lang),
          child: GestureDetector(
            onTap: () async {
              final uri = Uri.parse('mailto:${ClinicData.email}');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            child: Text(
              ClinicData.email,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _DetailTile(
          icon: Icons.location_on_outlined,
          title: ContactLabels.headquarters(lang),
          child: Text('${ClinicData.headquartersLabel}\n${ClinicData.headquartersCity}'),
          footer: GestureDetector(
            onTap: () => context.push('/locations'),
            child: Text(
              ContactLabels.viewAllLocations(lang),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _DetailTile(
          icon: Icons.access_time,
          title: ContactLabels.hours(lang),
          child: Text(ClinicData.hoursWeekday),
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? footer;

  const _DetailTile({
    required this.icon,
    required this.title,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                child,
                if (footer != null) ...[
                  const SizedBox(height: 4),
                  footer!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  final String lang;
  final ContactFormData form;
  final Map<String, String> errors;
  final bool submitting;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final ValueChanged<bool> onConsentChanged;
  final ValueChanged<String> onFieldChanged;
  final VoidCallback onSubmit;

  const _ContactForm({
    required this.lang,
    required this.form,
    required this.errors,
    required this.submitting,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.messageController,
    required this.onConsentChanged,
    required this.onFieldChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(ContactLabels.sendMessage(lang), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              ContactLabels.formHint(lang),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            Text(
              ContactLabels.yourDetails(lang),
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '${ContactLabels.email(lang)} *',
                errorText: errors['email'],
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => onFieldChanged('email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: ContactLabels.phone(lang),
                errorText: errors['phone'],
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => onFieldChanged('phone'),
            ),
            const SizedBox(height: 20),
            Text(
              ContactLabels.message(lang),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: '${ContactLabels.message(lang)} *',
                errorText: errors['message'],
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => onFieldChanged('message'),
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
                  Text('${ContactLabels.consent(lang)} '),
                  GestureDetector(
                    onTap: () => context.push('/more/privacy-policy'),
                    child: Text(
                      ContactLabels.privacyPolicy(lang),
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
              child: Text(submitting ? ContactLabels.sending(lang) : ContactLabels.send(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
