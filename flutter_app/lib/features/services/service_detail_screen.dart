import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/service_details_repository.dart';
import '../../providers/language_provider.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String slug;

  const ServiceDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final service = ServiceDetailRepository.getView(slug, lang);

    if (service == null) {
      return const Center(child: Text('Service not found'));
    }

    final heroHeight = context.isTablet ? 260.0 : 200.0;
    final showBody = service.bodyImagePath != null &&
        service.bodyImagePath != service.heroImagePath;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroImage(
            assetPath: service.heroImagePath,
            fallbackPath: service.imageFallback,
            height: heroHeight,
          ),
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => context.go('/services'),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('All services'),
                ),
                Text(service.title, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(service.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                Text('About this service', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (showBody)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(service.overview, style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      if (context.isTablet) ...[
                        const SizedBox(width: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AssetImageWithFallback(
                            assetPath: service.bodyImagePath!,
                            fallbackPath: service.imageFallback,
                            width: 200,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  )
                else
                  Text(service.overview, style: Theme.of(context).textTheme.bodyLarge),
                if (showBody && !context.isTablet) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AssetImageWithFallback(
                      assetPath: service.bodyImagePath!,
                      fallbackPath: service.imageFallback,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text('Conditions we treat', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...service.conditions.map((c) => _Bullet(text: c)),
                const SizedBox(height: 20),
                Text('Treatments & services', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...service.treatments.map((t) => _Bullet(text: t)),
                const SizedBox(height: 20),
                Card(
                  color: AppColors.primarySoft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      service.additionalInfo,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.push('/more/book-appointment'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Book Appointment'),
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

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
