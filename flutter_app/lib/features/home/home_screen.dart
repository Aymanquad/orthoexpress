import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final heroHeight = context.heroHeight;
    final infoColumns = context.isPhone ? 1 : (context.isLargeTablet ? 3 : 2);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: heroHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                HeroImage(
                  assetPath: 'assets/images/home/hero.jpg',
                  fallbackPath: 'assets/images/recovery-after-orthopedicsurgery.jpg',
                  height: heroHeight,
                ),
                Positioned(
                  left: context.pagePadding.left,
                  right: context.pagePadding.right,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Walk-In Orthopedic Care',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expert care when you need it',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontSize: context.isCompactPhone ? 24 : null,
                            ),
                      ),
                      const SizedBox(height: 16),
                      if (context.isCompactPhone)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PrimaryButton(
                              label: 'Book',
                              expanded: true,
                              onPressed: () => context.push('/more/book-appointment'),
                            ),
                            const SizedBox(height: 10),
                            SecondaryButton(
                              label: 'Find Center',
                              icon: Icons.location_on,
                              expanded: true,
                              onPressed: () => context.go('/locations'),
                            ),
                          ],
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            PrimaryButton(
                              label: 'Book Appointment',
                              onPressed: () => context.push('/more/book-appointment'),
                            ),
                            SecondaryButton(
                              label: 'Find Center',
                              icon: Icons.location_on,
                              onPressed: () => context.go('/locations'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Same-day orthopedic care',
                  subtitle: ClinicData.tagline,
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final effectiveColumns =
                        constraints.maxWidth < 480 ? 1 : infoColumns;

                    if (effectiveColumns == 1) {
                      return Column(
                        children: _infoCards(context),
                      );
                    }

                    final spacing = 12.0;
                    final itemWidth = (constraints.maxWidth -
                            spacing * (effectiveColumns - 1)) /
                        effectiveColumns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: _infoCards(context).map((card) {
                        return SizedBox(width: itemWidth, child: card);
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text('Quick links', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickChip(label: 'Services', onTap: () => context.go('/services')),
                    _QuickChip(label: 'Ortho Shop', onTap: () => context.go('/shop')),
                    _QuickChip(label: 'Blogs', onTap: () => context.push('/more/blogs')),
                    _QuickChip(label: 'FAQs', onTap: () => context.push('/more/faqs')),
                    _QuickChip(label: 'Contact', onTap: () => context.push('/more/contact-us')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _infoCards(BuildContext context) {
    return [
      _InfoCard(
        icon: Icons.emergency,
        title: 'Urgent orthopedic care',
        body: 'Walk in for sprains, fractures, and acute pain.',
        actionLabel: ClinicData.headquartersPhone,
        onAction: () async {
          final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
      ),
      _InfoCard(
        icon: Icons.star,
        title: 'Trusted by patients',
        body:
            '${ClinicData.googleRating} ★ from ${ClinicData.googleReviewCount}+ Google reviews.',
      ),
      _InfoCard(
        icon: Icons.access_time,
        title: ClinicData.hoursShort,
        body: 'Multiple locations · Telehealth available',
        actionLabel: 'View locations',
        onAction: () => context.go('/locations'),
      ),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 120;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: narrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: AppColors.accent, size: 28),
                      const SizedBox(height: 10),
                      _buildContent(context),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: AppColors.accent, size: 28),
                      const SizedBox(width: 14),
                      Expanded(child: _buildContent(context)),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(body, style: Theme.of(context).textTheme.bodyMedium),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: AppColors.primarySoft,
      onPressed: onTap,
    );
  }
}
