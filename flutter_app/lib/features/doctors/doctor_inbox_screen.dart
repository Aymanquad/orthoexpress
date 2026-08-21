import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/doctor_labels.dart';
import '../../data/doctors.dart';
import '../../providers/chat_provider.dart';
import '../../providers/doctor_auth_provider.dart';
import '../../providers/language_provider.dart';

class DoctorInboxScreen extends StatefulWidget {
  const DoctorInboxScreen({super.key});

  @override
  State<DoctorInboxScreen> createState() => _DoctorInboxScreenState();
}

class _DoctorInboxScreenState extends State<DoctorInboxScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chat = context.read<ChatProvider>();
      await chat.load();
    });
  }

  Future<void> _signOut() async {
    await context.read<DoctorAuthProvider>().logout();
    if (mounted) context.go('/more');
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final doctorAuth = context.watch<DoctorAuthProvider>();
    final chat = context.watch<ChatProvider>();
    final doctor = doctorAuth.doctor;

    if (doctor == null) {
      return ResponsiveScrollPage(
        children: [
          Text(
            DoctorLabels.doctorInbox.forLang(lang),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            DoctorLabels.doctorLoginLead.forLang(lang),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/more/doctors/login'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            child: Text(DoctorLabels.signIn.forLang(lang)),
          ),
        ],
      );
    }

    final conversations = chat.conversationsForDoctor(doctor.id);
    final awaiting = chat.awaitingReplyCount(doctor.id);

    return ResponsiveScrollPage(
      onRefresh: () => chat.load(),
      children: [
        _DoctorPortalHeader(doctor: doctor, lang: lang),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: DoctorLabels.openChats.forLang(lang),
                value: '${conversations.length}',
                icon: Icons.forum_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: DoctorLabels.awaitingReply.forLang(lang),
                value: '$awaiting',
                icon: Icons.mark_chat_unread_outlined,
                accent: awaiting > 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primarySoft.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DoctorLabels.portalTip.forLang(lang),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          DoctorLabels.patientMessages.forLang(lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (conversations.isEmpty)
          _EmptyInbox(lang: lang)
        else
          ...conversations.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ConversationTile(
                conversation: c,
                lang: lang,
                onTap: () => context.push(
                  '/more/doctors/chat/${doctor.id}?c=${Uri.encodeComponent(c.id)}',
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: _signOut,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textLight,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              DoctorLabels.signOutDoctor.forLang(lang),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DoctorPortalHeader extends StatelessWidget {
  final Doctor doctor;
  final String lang;

  const _DoctorPortalHeader({required this.doctor, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            child: Text(
              doctor.monogram,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${doctor.specialty.forLang(lang)} · ${doctor.clinic.forLang(lang)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: doctor.availableNow
                        ? AppColors.accent.withValues(alpha: 0.25)
                        : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    doctor.availableNow
                        ? DoctorLabels.availableNow.forLang(lang)
                        : DoctorLabels.away.forLang(lang),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool accent;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent ? AppColors.accent.withValues(alpha: 0.35) : AppColors.border,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: accent ? AppColors.accent : AppColors.primary),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent ? AppColors.accentHover : AppColors.textDark,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  final String lang;
  const _EmptyInbox({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 36, color: AppColors.textMuted.withValues(alpha: 0.8)),
          const SizedBox(height: 12),
          Text(
            DoctorLabels.noConversations.forLang(lang),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final String lang;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = conversation.patientName.isNotEmpty
        ? conversation.patientName
        : (conversation.patientPhone.isNotEmpty
            ? conversation.patientPhone
            : DoctorLabels.patient.forLang(lang));
    final when = DateFormat.MMMd().add_jm().format(conversation.updatedAt.toLocal());
    final unread = conversation.unreadForDoctor;

    return Material(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: unread ? AppColors.accent.withValues(alpha: 0.35) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primarySoft,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'P',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (unread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (unread)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              DoctorLabels.newFromPatient.forLang(lang),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.accentHover,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    if (conversation.patientPhone.isNotEmpty &&
                        conversation.patientName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        conversation.patientPhone,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      DoctorLabels.lastMessagePreview(lang, conversation.lastMessage),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      when,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
