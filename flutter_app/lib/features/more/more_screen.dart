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
        Text(NavLabels.more.forLang(lang), style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        _Section(
          title: NavLabels.patientCare.forLang(lang),
          items: [
            _LinkItem(NavLabels.telehealth.forLang(lang), '/more/telehealth'),
            _LinkItem(NavLabels.afterVisit.forLang(lang), '/more/after-your-visit'),
            _LinkItem(NavLabels.patientPortal.forLang(lang), '/more/patient-portal'),
            _LinkItem(NavLabels.technology.forLang(lang), '/more/technology'),
          ],
        ),
        _Section(
          title: NavLabels.company.forLang(lang),
          items: [
            _LinkItem(NavLabels.aboutUs.forLang(lang), '/more/about'),
            _LinkItem(NavLabels.workersComp.forLang(lang), '/more/workers-comp'),
            _LinkItem(NavLabels.careers.forLang(lang), '/more/careers'),
            _LinkItem(NavLabels.news.forLang(lang), '/more/news'),
          ],
        ),
        _Section(
          title: NavLabels.resources.forLang(lang),
          items: [
            _LinkItem(NavLabels.blogs.forLang(lang), '/more/blogs'),
            _LinkItem(NavLabels.faqs.forLang(lang), '/more/faqs'),
            _LinkItem(NavLabels.paymentAndInsurance.forLang(lang), '/more/payment'),
            _LinkItem(NavLabels.contact.forLang(lang), '/more/contact-us'),
            _LinkItem(NavLabels.bookAppointmentShort.forLang(lang), '/more/book-appointment'),
          ],
        ),
        _Section(
          title: NavLabels.legal.forLang(lang),
          items: [
            _LinkItem(NavLabels.privacyPolicy.forLang(lang), '/more/privacy-policy'),
            _LinkItem(NavLabels.termsOfService.forLang(lang), '/more/terms'),
            _LinkItem(NavLabels.accessibility.forLang(lang), '/more/accessibility'),
          ],
        ),
      ],
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
          child: Column(
            children: items.map((item) {
              return ListTile(
                title: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () => context.push(item.path),
              );
            }).toList(),
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

  const _LinkItem(this.label, this.path);
}
