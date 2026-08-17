import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/locations.dart';
import '../../data/page_labels.dart';
import '../../data/service_images.dart';
import '../../providers/language_provider.dart';

class WorkersCompScreen extends StatelessWidget {
  const WorkersCompScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final images = ServiceImages.forSlug('workers-comp');

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeroBanner(
              assetPath: images.src,
              fallbackPath: images.fallback,
              minHeight: context.isTablet ? 320 : 300,
              alignment: images.alignment,
              bookLabel: ServiceDetailLabels.bookAppointment.forLang(lang),
              onBook: () => context.push('/more/book-appointment'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    WorkersCompLabels.eyebrow.forLang(lang),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    WorkersCompLabels.title.forLang(lang),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    WorkersCompLabels.lead.forLang(lang),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ),
            ResponsivePage(
              child: context.isTablet
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _MainContent(lang: lang),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 2,
                          child: _LocationsSidebar(lang: lang),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _MainContent(lang: lang),
                        const SizedBox(height: 24),
                        _LocationsSidebar(lang: lang),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final String lang;

  const _MainContent({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          WorkersCompLabels.intro1.forLang(lang),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Text(
          WorkersCompLabels.intro2.forLang(lang),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 24),
        for (final section in WorkersCompLabels.sections) ...[
          Text(
            section.heading.forLang(lang),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            section.text.forLang(lang),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _LocationsSidebar extends StatelessWidget {
  final String lang;

  const _LocationsSidebar({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.bgSoft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              WorkersCompLabels.locationsTitle.forLang(lang),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final location in locations)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.place_outlined, color: AppColors.primary, size: 20),
                title: Text(location.name),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => context.push('/locations/${location.slug}'),
              ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => context.push('/more/book-appointment'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size.fromHeight(44),
              ),
              child: Text(WorkersCompLabels.bookLink.forLang(lang)),
            ),
          ],
        ),
      ),
    );
  }
}
