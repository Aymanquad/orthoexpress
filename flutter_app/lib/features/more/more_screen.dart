import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/nav_labels.dart';
import '../../providers/language_provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ResponsiveScrollPage(
      children: [
        Row(
          children: [
            Expanded(
              child: _PinnedAction(
                icon: Icons.calendar_month_rounded,
                label: NavLabels.bookAppointmentShort.forLang(lang),
                filled: true,
                onTap: () => context.push('/more/book-appointment'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PinnedAction(
                icon: Icons.mail_outline_rounded,
                label: NavLabels.contactShort.forLang(lang),
                filled: false,
                onTap: () => context.push('/more/contact-us'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _Section(
          title: NavLabels.patientCare.forLang(lang),
          items: [
            _LinkItem(NavLabels.telehealth.forLang(lang), '/more/telehealth', Icons.videocam_outlined),
            _LinkItem(NavLabels.afterVisit.forLang(lang), '/more/after-your-visit', Icons.healing_outlined),
            _LinkItem(NavLabels.patientPortal.forLang(lang), '/more/patient-portal', Icons.badge_outlined),
            _LinkItem(NavLabels.technology.forLang(lang), '/more/technology', Icons.memory_outlined),
          ],
        ),
        _Section(
          title: NavLabels.company.forLang(lang),
          items: [
            _LinkItem(NavLabels.aboutUs.forLang(lang), '/more/about', Icons.info_outline_rounded),
            _LinkItem(NavLabels.workersComp.forLang(lang), '/more/workers-comp', Icons.work_outline_rounded),
            _LinkItem(NavLabels.careers.forLang(lang), '/more/careers', Icons.groups_outlined),
            _LinkItem(NavLabels.news.forLang(lang), '/more/news', Icons.newspaper_outlined),
          ],
        ),
        _Section(
          title: NavLabels.resources.forLang(lang),
          items: [
            _LinkItem(NavLabels.blogs.forLang(lang), '/more/blogs', Icons.article_outlined),
            _LinkItem(NavLabels.faqs.forLang(lang), '/more/faqs', Icons.help_outline_rounded),
            _LinkItem(NavLabels.paymentAndInsurance.forLang(lang), '/more/payment', Icons.payments_outlined),
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
      ],
    );
  }
}

class _PinnedAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PinnedAction({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : AppColors.primary;
    return Card(
      color: filled ? AppColors.accent : AppColors.bgWhite,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w700,
                    ),
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                ListTile(
                  leading: Icon(items[i].icon, color: AppColors.primary),
                  title: Text(
                    items[i].label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  onTap: () => context.push(items[i].path),
                ),
                if (i < items.length - 1) const Divider(height: 1, indent: 72),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LinkItem {
  final String label;
  final String path;
  final IconData icon;

  const _LinkItem(this.label, this.path, this.icon);
}
