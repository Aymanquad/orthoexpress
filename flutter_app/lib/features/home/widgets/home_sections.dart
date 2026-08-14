import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_config.dart';
import '../../../config/theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/asset_image.dart';
import '../../../data/clinic.dart';
import '../../../data/content_repository.dart';
import '../../../data/home_labels.dart';
import '../../../data/locations.dart';
import '../../../data/service_images.dart';
import '../../../providers/language_provider.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final heroHeight = context.heroHeight;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HeroImage(
            assetPath: 'assets/images/home/hero.jpg',
            fallbackPath: 'assets/images/recovery-after-orthopedicsurgery.jpg',
            height: heroHeight,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          Positioned(
            left: context.pagePadding.left,
            right: context.pagePadding.right,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HomeLabels.heroEyebrow(lang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  HomeLabels.heroTitle(lang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: context.isCompactPhone ? 24 : null,
                      ),
                ),
                Text(
                  HomeLabels.heroTitleAccent(lang),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.accentLight,
                        fontWeight: FontWeight.w600,
                        fontSize: context.isCompactPhone ? 16 : null,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  HomeLabels.heroLead(lang),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
                const SizedBox(height: 16),
                if (context.isPhone)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        label: context.isCompactPhone
                            ? (lang == 'es' ? 'Cita' : 'Book')
                            : HomeLabels.heroBook(lang),
                        expanded: true,
                        onPressed: () => context.push('/more/book-appointment'),
                      ),
                      const SizedBox(height: 8),
                      SecondaryButton(
                        label: HomeLabels.heroFindCenter(lang),
                        icon: Icons.location_on,
                        expanded: true,
                        onPressed: () => context.go('/locations'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(
                            ClinicData.telLink(ClinicData.headquartersPhone),
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        icon: const Icon(Icons.phone, size: 18),
                        label: Text(
                          context.isCompactPhone
                              ? (lang == 'es' ? 'Llamar' : 'Call')
                              : ClinicData.headquartersPhone,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PrimaryButton(
                        label: HomeLabels.heroBook(lang),
                        onPressed: () => context.push('/more/book-appointment'),
                      ),
                      SecondaryButton(
                        label: HomeLabels.heroFindCenter(lang),
                        icon: Icons.location_on,
                        onPressed: () => context.go('/locations'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(
                            ClinicData.telLink(ClinicData.headquartersPhone),
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        icon: const Icon(Icons.phone, size: 18),
                        label: Text(ClinicData.headquartersPhone),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                if (context.isPhone)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TrustChip(HomeLabels.heroTrustWalkIn(lang), fullWidth: true),
                      _TrustChip(HomeLabels.heroTrustSameDay(lang), fullWidth: true),
                      _TrustChip(HomeLabels.heroTrustInsurance(lang), fullWidth: true),
                    ],
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _TrustChip(HomeLabels.heroTrustWalkIn(lang)),
                      _TrustChip(HomeLabels.heroTrustSameDay(lang)),
                      _TrustChip(HomeLabels.heroTrustInsurance(lang)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  final String label;
  final bool fullWidth;
  const _TrustChip(this.label, {this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.92),
          ),
    );
  return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.accentLight, size: 16),
          const SizedBox(width: 4),
          if (fullWidth) Expanded(child: text) else Flexible(child: text),
        ],
      ),
    );
  }
}

class WhatWeTreatSection extends StatelessWidget {
  const WhatWeTreatSection({super.key});

  static const _cards = [
    _TreatCard('injured', 'assets/images/home/snapshot-injured.jpg', '/services/injuries-fractures-sprains'),
    _TreatCard('pain', null, '/services/pain-inflammation', slug: 'arthritis'),
    _TreatCard('scan', null, '/services/mri-digital-imaging', slug: 'mri-digital-imaging'),
    _TreatCard('sports', 'assets/images/home/snapshot-sports.jpg', '/services/sports-medicine'),
    _TreatCard('spine', null, '/services/lumbar-cervical-spine', slug: 'lumbar-cervical-spine'),
    _TreatCard('workers', 'assets/images/home/snapshot-workers.jpg', '/more/workers-comp'),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final columns = context.isPhone ? 2 : (context.isTablet ? 3 : 3);

    return _HomeSection(
      title: HomeLabels.treatTitle(lang),
      subtitle: HomeLabels.treatSubtitle(lang),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: context.isPhone ? 0.95 : 1.1,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              final imagePath = card.imagePath ??
                  ServiceImages.forSlug(card.slug!).src;
              return _ImageLinkCard(
                imagePath: imagePath,
                label: HomeLabels.treatCard(card.key, lang),
                onTap: () => context.push(card.path),
              );
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.go('/services'),
              child: Text(HomeLabels.treatViewAll(lang)),
            ),
          ),
        ],
      ),
    );
  }
}

class HowWeCareSection extends StatelessWidget {
  const HowWeCareSection({super.key});

  static final _tiles = [
    _CareTile('diagnose', 'mri-digital-imaging', '/services/mri-digital-imaging'),
    _CareTile('treat', 'pain-inflammation', '/services/pain-inflammation'),
    _CareTile('surgery', 'total-joint-replacement', '/services/total-joint-replacement'),
    _CareTile('recover', 'sports-medicine', '/services/sports-medicine'),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return _HomeSection(
      title: HomeLabels.howWeCareTitle(lang),
      subtitle: HomeLabels.howWeCareSubtitle(lang),
      child: Column(
        children: List.generate(_tiles.length, (index) {
          final tile = _tiles[index];
          final images = ServiceImages.forSlug(tile.slug);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(tile.path),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.isPhone ? 100 : 120,
                    height: context.isPhone ? 100 : 120,
                    child: AssetImageWithFallback(
                      assetPath: images.src,
                      fallbackPath: images.fallback,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${(index + 1).toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            HomeLabels.howWeCareTileTitle(tile.key, lang),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(HomeLabels.howWeCareTileDesc(tile.key, lang)),
                          const SizedBox(height: 6),
                          Text(
                            '${HomeLabels.learnMore(lang)} →',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LocationsPreviewSection extends StatelessWidget {
  const LocationsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return _HomeSection(
      eyebrow: HomeLabels.locationsLabel(lang),
      title: HomeLabels.locationsTitle(lang),
      subtitle: HomeLabels.locationsSubtitle(lang),
      trailing: TextButton(
        onPressed: () => context.go('/locations'),
        child: Text('${HomeLabels.locationsViewAll(lang)} →'),
      ),
      child: Column(
        children: locations.map((loc) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => context.push('/locations/${loc.slug}'),
                  child: AssetImageWithFallback(
                    assetPath: loc.imagePath,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('${loc.address}\n${loc.city}'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(ClinicData.telLink(loc.phone));
                              if (await canLaunchUrl(uri)) await launchUrl(uri);
                            },
                            icon: const Icon(Icons.phone_outlined, size: 18),
                            label: Text(HomeLabels.locationsCall(lang)),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => context.push('/locations/${loc.slug}'),
                            icon: const Icon(Icons.store_outlined, size: 18),
                            label: Text(HomeLabels.locationsViewClinic(lang)),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(
                                ClinicData.mapsSearchUrl('${loc.address}, ${loc.city}'),
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(Icons.directions_outlined, size: 18),
                            label: Text(HomeLabels.locationsDirections(lang)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final reviews = ContentRepository.patientReviews.take(3).toList();

    return _HomeSection(
      title: HomeLabels.reviewsTitle(lang),
      subtitle: HomeLabels.reviewsSubtitle(lang),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _StatBadge(label: '150K+', caption: HomeLabels.statsHappyPatients(lang)),
              const SizedBox(width: 12),
              _StatBadge(label: '200K+', caption: HomeLabels.statsPatientsServed(lang)),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HomeLabels.reviewsGoogle(lang),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (_) => const Icon(Icons.star, color: Colors.amber, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${ClinicData.googleRating} ${HomeLabels.reviewsRatingLabel(lang)}',
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    HomeLabels.reviewsCount(lang, ClinicData.googleReviewCount),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          final url = AppConfig.googleReviewsUrl.isNotEmpty
                              ? AppConfig.googleReviewsUrl
                              : ClinicData.googleMapsUrl;
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(HomeLabels.reviewsViewOnGoogle(lang)),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final url = AppConfig.googleReviewsUrl.isNotEmpty
                              ? AppConfig.googleReviewsUrl
                              : ClinicData.googleMapsUrl;
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(HomeLabels.reviewsWriteOnGoogle(lang)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            HomeLabels.reviewsPowered(lang),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          ...reviews.map(
            (r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primarySoft,
                          child: Text(
                            r.name.isNotEmpty ? r.name[0] : '?',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                r.when.forLang(lang),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('"${r.text.forLang(lang)}"'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsuranceSection extends StatelessWidget {
  const InsuranceSection({super.key});

  static const _providers = [
    'AETNA',
    'Cigna',
    'United Healthcare',
    'Florida Blue',
    'Medicare',
    'Medicaid',
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return _HomeSection(
      title: HomeLabels.insuranceTitle(lang),
      subtitle: HomeLabels.insuranceSubtitle(lang),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HomeLabels.insuranceNoInsurance(lang),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._providers.map(
                (p) => Chip(
                  label: Text(p),
                  backgroundColor: AppColors.primarySoft,
                ),
              ),
              Chip(
                label: Text(HomeLabels.insuranceAndMore(lang)),
                backgroundColor: AppColors.bgSoft,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
                icon: const Icon(Icons.phone_outlined),
                label: Text(
                  context.isCompactPhone
                      ? HomeLabels.insuranceVerify(lang)
                      : '${HomeLabels.insuranceVerify(lang)} · ${ClinicData.headquartersPhone}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/more/payment'),
                child: Text(HomeLabels.insuranceViewPricing(lang)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BlogPreviewSection extends StatelessWidget {
  const BlogPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final blogs = ContentRepository.blogs.take(3).toList();

    return _HomeSection(
      title: HomeLabels.blogTitle(lang),
      trailing: TextButton(
        onPressed: () => context.push('/more/blogs'),
        child: Text(HomeLabels.blogAll(lang)),
      ),
      child: Column(
        children: blogs.map((blog) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push('/more/blogs/${blog.slug}'),
              child: Row(
                children: [
                  AssetImageWithFallback(
                    assetPath: blog.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.category.forLang(lang),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            blog.title.forLang(lang),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            HomeLabels.blogReadMore(lang),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const _HomeSection({
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Text(
              eyebrow!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
            ),
            const SizedBox(height: 6),
          ],
          if (context.isCompactPhone)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                ],
                if (trailing != null) trailing!,
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineMedium),
                      if (subtitle != null) ...[
                        const SizedBox(height: 6),
                        Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ImageLinkCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const _ImageLinkCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AssetImageWithFallback(
                assetPath: imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String caption;

  const _StatBadge({required this.label, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(caption, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _TreatCard {
  final String key;
  final String? imagePath;
  final String path;
  final String? slug;

  const _TreatCard(this.key, this.imagePath, this.path, {this.slug});
}

class _CareTile {
  final String key;
  final String slug;
  final String path;

  const _CareTile(this.key, this.slug, this.path);
}
