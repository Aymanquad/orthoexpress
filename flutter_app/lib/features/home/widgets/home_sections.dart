import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: heroHeight),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Positioned.fill(
            child: HeroImage(
              assetPath: HomeImages.hero,
              fallbackPath: HomeImages.heroFallback,
              height: heroHeight,
              alignment: const Alignment(0, -0.4),
              overlay: const LinearGradient(
                begin: Alignment(-0.85, -0.2),
                end: Alignment(0.95, 0.4),
                colors: [
                  Color(0xD10A164E),
                  Color(0x9E0D1B6B),
                  Color(0x470D1B6B),
                  Color(0x1F0D1B6B),
                ],
                stops: [0.0, 0.38, 0.68, 1.0],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.pagePadding.left,
              20,
              context.pagePadding.right,
              18,
            ),
            child: Column(
              crossAxisAlignment:
                  context.isPhone ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: context.screenWidth - context.pagePadding.horizontal,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    HomeLabels.heroEyebrow(lang),
                    maxLines: 2,
                    textAlign: context.isPhone ? TextAlign.center : TextAlign.start,
                    softWrap: true,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  HomeLabels.heroTitle(lang),
                  maxLines: 2,
                  textAlign: context.isPhone ? TextAlign.center : TextAlign.start,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: context.isCompactPhone ? 22 : 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  HomeLabels.heroTitleAccent(lang),
                  maxLines: 2,
                  textAlign: context.isPhone ? TextAlign.center : TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  HomeLabels.heroLead(lang),
                  maxLines: 3,
                  textAlign: context.isPhone ? TextAlign.center : TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 14),
                if (context.isPhone)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        label: HomeLabels.heroBook(lang),
                        icon: Icons.calendar_month_rounded,
                        expanded: true,
                        onPressed: () => context.push('/more/book-appointment'),
                      ),
                      const SizedBox(height: 8),
                      GhostCallButton(
                        label: lang == 'es' ? 'Llamar' : ClinicData.headquartersPhone,
                        expanded: true,
                        onPressed: () async {
                          final uri = Uri.parse(
                            ClinicData.telLink(ClinicData.headquartersPhone),
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
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
                        icon: Icons.calendar_month_rounded,
                        onPressed: () => context.push('/more/book-appointment'),
                      ),
                      GhostCallButton(
                        label: ClinicData.headquartersPhone,
                        onPressed: () async {
                          final uri = Uri.parse(
                            ClinicData.telLink(ClinicData.headquartersPhone),
                          );
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: context.isPhone ? WrapAlignment.center : WrapAlignment.start,
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
  const _TrustChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.accentLight, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w500,
                  fontSize: context.isCompactPhone ? 10 : 11,
                ),
          ),
        ],
      ),
    );
  }
}

class WhatWeTreatSection extends StatelessWidget {
  const WhatWeTreatSection({super.key});

  static const _cards = [
    _TreatCard('injured', HomeImages.injured, '/services/injuries-fractures-sprains'),
    _TreatCard('pain', HomeImages.pain, '/services/pain-inflammation'),
    _TreatCard('scan', null, '/services/mri-digital-imaging', slug: 'mri-digital-imaging'),
    _TreatCard('sports', 'assets/images/home/snapshot-sports.jpg', '/services/sports-medicine'),
    _TreatCard('spine', null, '/services/lumbar-cervical-spine', slug: 'lumbar-cervical-spine'),
    _TreatCard('workers', HomeImages.workers, '/more/workers-comp'),
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
    _CareTile(
      'lawyers',
      '/more/lawyers',
      step: '00',
      imagePath: HomeImages.lawyers,
      fallbackPath: HomeImages.lawyersFallback,
      imageAlignment: const Alignment(0, -0.6),
    ),
    _CareTile('diagnose', '/services/mri-digital-imaging', step: '01', slug: 'mri-digital-imaging'),
    _CareTile('treat', '/services/pain-inflammation', step: '02', slug: 'pain-inflammation'),
    _CareTile('surgery', '/services/total-joint-replacement', step: '03', slug: 'total-joint-replacement'),
    _CareTile('recover', '/services/sports-medicine', step: '04', slug: 'sports-medicine'),
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
          final images = tile.slug != null ? ServiceImages.forSlug(tile.slug!) : null;
          final imagePath = tile.imagePath ?? images!.src;
          final fallbackPath = tile.fallbackPath ?? images?.fallback;
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
                      assetPath: imagePath,
                      fallbackPath: fallbackPath,
                      fit: BoxFit.cover,
                      alignment: tile.imageAlignment,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tile.step,
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
            child: InkWell(
              onTap: () => context.push('/locations/${loc.slug}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AssetImageWithFallback(
                    assetPath: loc.imagePath,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.name, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text('${loc.address}\n${loc.city}'),
                        const SizedBox(height: 12),
                        SecondaryButton(
                          label: HomeLabels.locationsCall(lang),
                          icon: Icons.phone_outlined,
                          expanded: true,
                          onPressed: () async {
                            final uri = Uri.parse(ClinicData.telLink(loc.phone));
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          },
                        ),
                      ],
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

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final review = ContentRepository.patientReviews.isEmpty
        ? null
        : ContentRepository.patientReviews.first;

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
                  SecondaryButton(
                    label: HomeLabels.reviewsViewOnGoogle(lang),
                    icon: Icons.open_in_new_rounded,
                    expanded: context.isPhone,
                    onPressed: () async {
                      final url = AppConfig.googleReviewsUrl.isNotEmpty
                          ? AppConfig.googleReviewsUrl
                          : ClinicData.googleMapsUrl;
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if (review != null) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primarySoft,
                          child: Text(
                            review.name.isNotEmpty ? review.name[0] : '?',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.name, style: Theme.of(context).textTheme.titleSmall),
                              Text(
                                review.when.forLang(lang),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('"${review.text.forLang(lang)}"'),
                  ],
                ),
              ),
            ),
          ],
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
          SecondaryButton(
            label: HomeLabels.insuranceVerify(lang),
            icon: Icons.phone_outlined,
            expanded: true,
            onPressed: () async {
              final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push('/more/payment'),
              child: Text(HomeLabels.insuranceViewPricing(lang)),
            ),
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
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Text(
              eyebrow!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 6),
          ],
          if (context.isPhone)
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
  final String path;
  final String step;
  final String? slug;
  final String? imagePath;
  final String? fallbackPath;
  final Alignment imageAlignment;

  const _CareTile(
    this.key,
    this.path, {
    required this.step,
    this.slug,
    this.imagePath,
    this.fallbackPath,
    this.imageAlignment = Alignment.center,
  });
}
