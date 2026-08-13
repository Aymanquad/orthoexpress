import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/page_labels.dart';
import '../../data/service_images.dart';
import '../../providers/language_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              HeroImage(
                assetPath: AboutImages.hero.src,
                fallbackPath: AboutImages.hero.fallback,
                height: 220,
              ),
              Positioned(
                left: 16,
                bottom: 24,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AboutLabels.title.forLang(lang),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AboutLabels.subtitle.forLang(lang),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _SplitSection(
            image: AboutImages.team,
            label: AboutLabels.missionLabel.forLang(lang),
            title: AboutLabels.missionTitle.forLang(lang),
            paragraphs: [
              AboutLabels.missionP1.forLang(lang),
              AboutLabels.missionP2.forLang(lang),
            ],
            imageFirst: true,
          ),
          _SplitSection(
            image: AboutImages.clinic,
            label: AboutLabels.visionLabel.forLang(lang),
            title: AboutLabels.visionTitle.forLang(lang),
            paragraphs: [
              AboutLabels.visionP1.forLang(lang),
              AboutLabels.visionP2.forLang(lang),
            ],
            imageFirst: false,
          ),
          _WhySection(lang: lang),
          _StorySection(lang: lang),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SplitSection extends StatelessWidget {
  final AboutImageSlot image;
  final String label;
  final String title;
  final List<String> paragraphs;
  final bool imageFirst;

  const _SplitSection({
    required this.image,
    required this.label,
    required this.title,
    required this.paragraphs,
    required this.imageFirst,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AssetImageWithFallback(
        assetPath: image.src,
        fallbackPath: image.fallback,
        height: context.isTablet ? 220 : 180,
        fit: BoxFit.cover,
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        for (final p in paragraphs) ...[
          Text(p, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
        ],
      ],
    );

    return Padding(
      padding: context.pagePadding.copyWith(top: 24, bottom: 8),
      child: context.isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: imageFirst
                  ? [Expanded(child: imageWidget), const SizedBox(width: 20), Expanded(child: text)]
                  : [Expanded(child: text), const SizedBox(width: 20), Expanded(child: imageWidget)],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                imageWidget,
                const SizedBox(height: 16),
                text,
              ],
            ),
    );
  }
}

class _WhySection extends StatelessWidget {
  final String lang;

  const _WhySection({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AboutImages.facility.src,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  AboutImages.facility.fallback,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: ColoredBox(color: AppColors.primary.withValues(alpha: 0.88)),
            ),
            Padding(
              padding: context.pagePadding.copyWith(top: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AboutLabels.whyLabel.forLang(lang).toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AboutLabels.whyTitle.forLang(lang),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ResponsiveCardGrid(
                    itemCount: AboutLabels.features.length,
                    itemBuilder: (context, i) {
                      final f = AboutLabels.features[i];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(f.icon, color: AppColors.accent, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              f.title.forLang(lang),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              f.text.forLang(lang),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  final String lang;

  const _StorySection({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AboutImages.care.src,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  AboutImages.care.fallback,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: context.pagePadding.copyWith(top: 28, bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AboutLabels.storyLabel.forLang(lang).toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AboutLabels.storyTitle.forLang(lang),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AboutLabels.storyP1.forLang(lang),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AboutLabels.storyP2.forLang(lang),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
