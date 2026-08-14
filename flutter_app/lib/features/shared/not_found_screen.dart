import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';
import '../../data/home_labels.dart';
import '../../data/nav_labels.dart';
import '../../providers/language_provider.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return SingleChildScrollView(
      child: ResponsivePage(
        alignTop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              NotFoundLabels.title(lang),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              NotFoundLabels.text(lang),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/home'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(NotFoundLabels.goHome(lang)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.push('/more/book-appointment'),
              child: Text(NotFoundLabels.bookAppointment(lang)),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              icon: const Icon(Icons.phone_outlined),
              label: Text(
                '${NotFoundLabels.call(lang)} ${ClinicData.headquartersPhone}',
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                TextButton(
                  onPressed: () => context.go('/locations'),
                  child: Text(NavLabels.locations.forLang(lang)),
                ),
                TextButton(
                  onPressed: () => context.push('/more/contact-us'),
                  child: Text(NavLabels.contact.forLang(lang)),
                ),
                TextButton(
                  onPressed: () => context.go('/services'),
                  child: Text(NavLabels.services.forLang(lang)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
