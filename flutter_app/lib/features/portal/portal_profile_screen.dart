import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/locations.dart';
import '../../data/portal_api.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import 'portal_login_screen.dart' show formatPortalPhone, friendlyAuthError;

class PortalProfileScreen extends StatefulWidget {
  const PortalProfileScreen({super.key});

  @override
  State<PortalProfileScreen> createState() => _PortalProfileScreenState();
}

class _PortalProfileScreenState extends State<PortalProfileScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  String? _preferredLocation;
  String _error = '';
  final _fieldErrors = <String, String>{};
  bool _loading = true;
  bool _saving = false;
  bool _hydrated = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final auth = context.read<PortalAuthProvider>();
    if (!auth.isAuthenticated) {
      if (mounted) context.go('/more/portal/login');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      await auth.refreshProfile();
    } catch (_) {
      // Fall back to cached patient if refresh fails.
    }

    if (!mounted) return;
    final patient = context.read<PortalAuthProvider>().patient;
    if (patient == null) {
      context.go('/more/portal/login');
      return;
    }

    _firstName.text = patient.firstName?.trim() ?? '';
    _lastName.text = patient.lastName?.trim() ?? '';
    _email.text = patient.email?.trim() ?? '';
    _phone.text = formatPortalPhone(patient.phone);
    _preferredLocation = context.read<PortalAuthProvider>().preferredLocationSlug;
    if (_preferredLocation != null &&
        locations.every((l) => l.slug != _preferredLocation)) {
      _preferredLocation = null;
    }

    setState(() {
      _loading = false;
      _hydrated = true;
    });
  }

  bool _validate(String lang) {
    final errors = <String, String>{};
    if (_firstName.text.trim().isEmpty) {
      errors['firstName'] = PortalLabels.firstNameRequired.forLang(lang);
    }
    final email = _email.text.trim();
    if (email.isNotEmpty &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      errors['email'] = PortalLabels.emailInvalid.forLang(lang);
    }
    final phoneDigits = _phone.text.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length != 10) {
      errors['phone'] = PortalLabels.invalidPhone.forLang(lang);
    }
    setState(() {
      _fieldErrors
        ..clear()
        ..addAll(errors);
      _error = '';
    });
    return errors.isEmpty;
  }

  Future<void> _save() async {
    final lang = context.read<LanguageProvider>().locale.languageCode;
    if (!_validate(lang)) return;

    setState(() => _saving = true);
    try {
      await context.read<PortalAuthProvider>().updateProfile(
            firstName: _firstName.text,
            lastName: _lastName.text,
            email: _email.text,
            phone: _phone.text,
            preferredLocationSlug: _preferredLocation ?? '',
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(PortalLabels.profileSaved.forLang(lang)),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => _saving = false);
    } catch (err) {
      if (!mounted) return;
      final raw = err.toString().toLowerCase();
      setState(() {
        _saving = false;
        if (raw.contains('already in use') || raw.contains('en uso')) {
          _error = PortalLabels.phoneInUse.forLang(lang);
        } else if (err is PortalApiException) {
          _error = friendlyAuthError(err, lang);
        } else {
          _error = friendlyAuthError(err, lang);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    if (_loading && !_hydrated) {
      return const Center(child: CircularProgressIndicator());
    }

    return ContentPageScaffold(
      title: PortalLabels.profileTitle.forLang(lang),
      lead: PortalLabels.profileLead.forLang(lang),
      onRefresh: _load,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: PortalLabels.firstName.forLang(lang),
                    errorText: _fieldErrors['firstName'],
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: PortalLabels.lastName.forLang(lang),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: PortalLabels.email.forLang(lang),
                    errorText: _fieldErrors['email'],
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  inputFormatters: [_PhoneInputFormatter()],
                  decoration: InputDecoration(
                    labelText: PortalLabels.phoneLabel.forLang(lang),
                    helperText: PortalLabels.phoneChangeHelp.forLang(lang),
                    helperMaxLines: 2,
                    errorText: _fieldErrors['phone'],
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone_iphone_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  // ignore: deprecated_member_use
                  value: _preferredLocation,
                  decoration: InputDecoration(
                    labelText: PortalLabels.preferredClinic.forLang(lang),
                    helperText: PortalLabels.preferredClinicHelp.forLang(lang),
                    helperMaxLines: 2,
                    border: const OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        PortalLabels.preferredClinicNone.forLang(lang),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...locations.map(
                      (loc) => DropdownMenuItem<String?>(
                        value: loc.slug,
                        child: Text(
                          '${loc.name} — ${loc.city}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _preferredLocation = v),
                ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error,
                    style: const TextStyle(
                      color: Color(0xFF991B1B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(PortalLabels.saveProfile.forLang(lang)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formatted = formatPortalPhone(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
