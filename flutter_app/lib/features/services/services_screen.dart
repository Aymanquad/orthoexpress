import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/page_labels.dart';
import '../../data/service_details_repository.dart';
import '../../data/service_labels.dart';
import '../../data/service_images.dart';
import '../../data/services.dart';
import '../../providers/language_provider.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ResponsiveScrollPage(
      onRefresh: () async {
        await ServiceDetailRepository.reload();
      },
      children: [
        Text(
          ServicesLabels.eyebrow.forLang(lang),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
        ),
        const SizedBox(height: 8),
        Text(ServicesLabels.title.forLang(lang), style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          ServicesLabels.intro.forLang(lang),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Text(ServicesLabels.coreHeading.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          ServicesLabels.coreLead.forLang(lang),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        ResponsiveCardGrid(
          itemCount: primaryServices.length,
          itemBuilder: (context, i) => _ServiceTile(
            service: primaryServices[i],
            lang: lang,
          ),
        ),
        const SizedBox(height: 24),
        Text(ServicesLabels.specialtyHeading.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          ServicesLabels.specialtyLead.forLang(lang),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        ResponsiveCardGrid(
          itemCount: specialtyServices.length,
          itemBuilder: (context, i) => _ServiceTile(
            service: specialtyServices[i],
            lang: lang,
          ),
        ),
        const SizedBox(height: 24),
        Text(ServicesLabels.workersHeading.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ListTile(
          tileColor: AppColors.bgSoft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.work_outline, color: AppColors.primary),
          title: Text(ServiceLabels.name('workers-comp', lang)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/more/workers-comp'),
        ),
        const SizedBox(height: 20),
        Text(
          ServicesLabels.ctaPrompt.forLang(lang),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
              onPressed: () => context.push('/more/contact-us'),
              child: Text(CommonLabels.contactUs.forLang(lang)),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceItem service;
  final String lang;

  const _ServiceTile({required this.service, required this.lang});

  @override
  Widget build(BuildContext context) {
    final name = ServiceLabels.name(service.slug, lang);
    final summary = ServiceLabels.summary(service.slug, lang);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/services/${service.slug}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AssetImageWithFallback(
              assetPath: serviceImagePath(service.slug),
              fallbackPath: ServiceImages.listFallbackPath(service.slug),
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                  if (summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
