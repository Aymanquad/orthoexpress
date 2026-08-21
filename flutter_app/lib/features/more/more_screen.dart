import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/doctor_labels.dart';
import '../../data/nav_labels.dart';
import '../../data/portal_labels.dart';
import '../../features/portal/portal_login_screen.dart'
    show confirmSignOut, formatPortalPhone;
import '../../providers/doctor_auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final signedIn = context.watch<PortalAuthProvider>().isAuthenticated;
    final patient = context.watch<PortalAuthProvider>().patient;
    final doctorSignedIn = context.watch<DoctorAuthProvider>().isAuthenticated;

    return ResponsiveScrollPage(
      children: [
        if (signedIn)
          _AccountHeader(
            lang: lang,
            name: patient?.displayFullName.isNotEmpty == true
                ? patient!.displayFullName
                : (patient?.displayFirstName ?? ''),
            phone: patient?.phone ?? '',
          )
        else
          _SignInCard(lang: lang),
        const SizedBox(height: 22),
        if (signedIn) ...[
          _Section(
            title: NavLabels.account.forLang(lang),
            items: [
              _LinkItem(
                PortalLabels.myProfile.forLang(lang),
                '/more/portal/profile',
                Icons.manage_accounts_outlined,
              ),
              _LinkItem(
                PortalLabels.myAppointments.forLang(lang),
                '/more/portal/appointments',
                Icons.event_note_outlined,
              ),
              _LinkItem(
                PortalLabels.myOrders.forLang(lang),
                '/shop/orders',
                Icons.receipt_long_outlined,
              ),
              _LinkItem(
                DoctorLabels.talkToDoctor.forLang(lang),
                '/more/doctors',
                Icons.phone_in_talk_outlined,
              ),
            ],
          ),
        ],
        _Section(
          title: NavLabels.yourCare.forLang(lang),
          items: [
            _LinkItem(NavLabels.telehealth.forLang(lang), '/more/telehealth', Icons.videocam_outlined),
            _LinkItem(NavLabels.afterVisit.forLang(lang), '/more/after-your-visit', Icons.healing_outlined),
            _LinkItem(NavLabels.paymentAndInsurance.forLang(lang), '/more/payment', Icons.payments_outlined),
            _LinkItem(NavLabels.faqs.forLang(lang), '/more/faqs', Icons.help_outline_rounded),
          ],
        ),
        _Section(
          title: NavLabels.helpAndInfo.forLang(lang),
          items: [
            _LinkItem(NavLabels.blogs.forLang(lang), '/more/blogs', Icons.article_outlined),
            _LinkItem(NavLabels.aboutUs.forLang(lang), '/more/about', Icons.info_outline_rounded),
            _LinkItem(NavLabels.workersComp.forLang(lang), '/more/workers-comp', Icons.work_outline_rounded),
            _LinkItem(NavLabels.contact.forLang(lang), '/more/contact-us', Icons.mail_outline_rounded),
            _LinkItem(
              doctorSignedIn
                  ? DoctorLabels.doctorInbox.forLang(lang)
                  : DoctorLabels.imADoctor.forLang(lang),
              doctorSignedIn ? '/more/doctors/inbox' : '/more/doctors/login',
              Icons.medical_services_outlined,
            ),
          ],
        ),
        _Section(
          title: NavLabels.legal.forLang(lang),
          items: [
            _LinkItem(NavLabels.privacyPolicy.forLang(lang), '/more/privacy-policy', Icons.shield_outlined),
            _LinkItem(NavLabels.termsOfService.forLang(lang), '/more/terms', Icons.description_outlined),
            _LinkItem(NavLabels.accessibility.forLang(lang), '/more/accessibility', Icons.accessibility_new_rounded),
          ],
        ),
        if (signedIn) ...[
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () async {
                final ok = await confirmSignOut(context, lang);
                if (!ok || !context.mounted) return;
                await context.read<PortalAuthProvider>().logout();
                if (!context.mounted) return;
                context.go('/home');
              },
              child: Text(
                PortalLabels.signOut.forLang(lang),
                style: const TextStyle(color: AppColors.textLight),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _AccountHeader extends StatelessWidget {
  final String lang;
  final String name;
  final String phone;

  const _AccountHeader({
    required this.lang,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = name.isEmpty
        ? PortalLabels.welcomeGuest.forLang(lang)
        : PortalLabels.welcome(lang, name.split(' ').first);
    final trimmed = name.trim();
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    final initial = trimmed.isNotEmpty
        ? trimmed.substring(0, 1).toUpperCase()
        : (phoneDigits.isNotEmpty ? phoneDigits.substring(0, 1) : '?');
    final displayPhone = phone.isEmpty ? '' : formatPortalPhone(phone);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  initial,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (displayPhone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        displayPhone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () => context.push('/more/portal/profile'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size.fromHeight(44),
            ),
            child: Text(PortalLabels.myProfile.forLang(lang)),
          ),
        ],
      ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  final String lang;

  const _SignInCard({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/more/portal/login'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PortalLabels.signInWithPhone.forLang(lang),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      PortalLabels.signInPromptBody.forLang(lang),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_LinkItem> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                  ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _MoreLinkTile(item: items[i]),
                  if (i < items.length - 1)
                    const Divider(height: 1, indent: 64, endIndent: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreLinkTile extends StatelessWidget {
  final _LinkItem item;

  const _MoreLinkTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.path.startsWith('/shop')) {
          context.go(item.path);
        } else {
          context.push(item.path);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(item.icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _LinkItem {
  final String label;
  final String path;
  final IconData icon;

  const _LinkItem(this.label, this.path, this.icon);
}
