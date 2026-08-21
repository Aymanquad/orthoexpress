import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/doctor_labels.dart';
import '../../data/doctors.dart';
import '../../providers/doctor_auth_provider.dart';
import '../../providers/language_provider.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _username = TextEditingController(text: 'dr.chen');
  final _password = TextEditingController(text: 'doctor123');
  bool _obscure = true;
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      await context.read<DoctorAuthProvider>().login(
            _username.text,
            _password.text,
          );
      if (!mounted) return;
      context.go('/more/doctors/inbox');
    } catch (_) {
      if (!mounted) return;
      final lang = context.read<LanguageProvider>().locale.languageCode;
      setState(() => _error = DoctorLabels.invalidLogin.forLang(lang));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fillDemo(Doctor doctor) {
    setState(() {
      _username.text = doctor.username;
      _password.text = doctor.password;
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    // Avoid go() in build — this route can remain mounted in the shell stack.

    return ContentPageScaffold(
      title: DoctorLabels.doctorLogin.forLang(lang),
      lead: DoctorLabels.doctorLoginLead.forLang(lang),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _username,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: DoctorLabels.username.forLang(lang),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: _obscure,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: DoctorLabels.password.forLang(lang),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  _error,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loading ? null : _submit,
                icon: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(DoctorLabels.signIn.forLang(lang)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          lang == 'es' ? 'Cuentas demo' : 'Demo accounts',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          DoctorLabels.demoHint.forLang(lang),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
        const SizedBox(height: 12),
        ...demoDoctors.take(4).map(
              (d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AppColors.bgWhite,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _fillDemo(d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primarySoft,
                            child: Text(
                              d.monogram,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  d.username,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            lang == 'es' ? 'Usar' : 'Use',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.accentHover,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
