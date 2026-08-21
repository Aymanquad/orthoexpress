import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/doctor_labels.dart';
import '../../data/doctors.dart';
import '../../providers/doctor_auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final patientAuth = context.watch<PortalAuthProvider>();
    final doctorAuth = context.watch<DoctorAuthProvider>();

    if (!patientAuth.isAuthenticated) {
      return ContentPageScaffold(
        title: DoctorLabels.title.forLang(lang),
        lead: DoctorLabels.signInRequired.forLang(lang),
        children: [
          PrimaryButton(
            label: PortalAuthCta.signIn(lang),
            icon: Icons.login_rounded,
            expanded: true,
            onPressed: () => context.push('/more/portal/login'),
          ),
        ],
      );
    }

    return ContentPageScaffold(
      title: DoctorLabels.title.forLang(lang),
      lead: DoctorLabels.lead.forLang(lang),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primarySoft.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  DoctorLabels.emergencyNote.forLang(lang),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...demoDoctors.map(
          (doctor) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DoctorCard(
              doctor: doctor,
              lang: lang,
              onCall: () => context.push('/more/doctors/call/${doctor.id}'),
              onChat: () => context.push('/more/doctors/chat/${doctor.id}'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              if (doctorAuth.isAuthenticated) {
                context.push('/more/doctors/inbox');
              } else {
                context.push('/more/doctors/login');
              }
            },
            icon: const Icon(Icons.medical_services_outlined, size: 18),
            label: Text(
              doctorAuth.isAuthenticated
                  ? DoctorLabels.doctorInbox.forLang(lang)
                  : DoctorLabels.imADoctor.forLang(lang),
            ),
          ),
        ),
      ],
    );
  }
}

class PortalAuthCta {
  static String signIn(String lang) =>
      lang == 'es' ? 'Iniciar sesión' : 'Sign in';
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final String lang;
  final VoidCallback onCall;
  final VoidCallback onChat;

  const _DoctorCard({
    required this.doctor,
    required this.lang,
    required this.onCall,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final available = doctor.availableNow;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  doctor.monogram,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty.forLang(lang),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                    Text(
                      doctor.clinic.forLang(lang),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: available
                      ? AppColors.accent.withValues(alpha: 0.12)
                      : AppColors.bgSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  available
                      ? DoctorLabels.availableNow.forLang(lang)
                      : DoctorLabels.away.forLang(lang),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: available ? AppColors.accentHover : AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            doctor.bio.forLang(lang),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: DoctorLabels.call.forLang(lang),
                  icon: Icons.call_outlined,
                  expanded: true,
                  onPressed: onCall,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  label: DoctorLabels.chat.forLang(lang),
                  icon: Icons.chat_bubble_outline_rounded,
                  expanded: true,
                  onPressed: onChat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
