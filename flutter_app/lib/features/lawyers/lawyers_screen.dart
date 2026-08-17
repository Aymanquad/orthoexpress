import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/lawyers.dart';
import '../../data/page_labels.dart';
import '../../data/service_images.dart';
import '../../providers/language_provider.dart';

class LawyersScreen extends StatelessWidget {
  const LawyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeroBanner(
            assetPath: HomeImages.lawyers,
            fallbackPath: HomeImages.lawyersFallback,
            minHeight: context.isTablet ? 320 : 300,
            alignment: const Alignment(0, -0.56),
            bookLabel: ServiceDetailLabels.bookAppointment.forLang(lang),
            onBook: () => context.push('/more/book-appointment'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LawyersLabels.eyebrow.forLang(lang),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  LawyersLabels.title.forLang(lang),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  LawyersLabels.lead.forLang(lang),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  LawyersLabels.aboutHeading.forLang(lang),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  LawyersLabels.aboutP1.forLang(lang),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  LawyersLabels.aboutP2.forLang(lang),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  color: AppColors.primarySoft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.balance_rounded, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          LawyersLabels.helpTitle.forLang(lang),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(LawyersLabels.helpText.forLang(lang)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.push('/more/contact-us'),
                          child: Text(CommonLabels.contactUs.forLang(lang)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  LawyersLabels.listHeading.forLang(lang),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  LawyersLabels.listLead.forLang(lang),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${laLawyers.length} ${LawyersLabels.listed.forLang(lang)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < laLawyers.length; i++)
                  _LawyerRow(index: i, lawyer: laLawyers[i], lang: lang),
                const SizedBox(height: 12),
                Text(
                  LawyersLabels.disclaimer.forLang(lang),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  LawyersLabels.ctaTitle.forLang(lang),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(LawyersLabels.ctaText.forLang(lang)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => context.push('/more/book-appointment'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                      child: Text(CommonLabels.bookAppointment.forLang(lang)),
                    ),
                    OutlinedButton(
                      onPressed: () => context.push(
                        '/services/car-motor-vehicle-accident-care',
                      ),
                      child: Text(LawyersLabels.ctaAccident.forLang(lang)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LawyerRow extends StatelessWidget {
  final int index;
  final LawyerListing lawyer;
  final String lang;

  const _LawyerRow({
    required this.index,
    required this.lawyer,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lawyer.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      lawyer.focus.forLang(lang),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lawyer.area,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
