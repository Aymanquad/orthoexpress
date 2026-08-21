import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/content_repository.dart';
import 'responsive_page.dart';

class ContentPageScaffold extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? lead;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  const ContentPageScaffold({
    super.key,
    this.eyebrow,
    required this.title,
    this.lead,
    required this.children,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollPage(
      onRefresh: onRefresh,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
          ),
          const SizedBox(height: 6),
        ],
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        if (lead != null) ...[
          const SizedBox(height: 8),
          Text(
            lead!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  height: 1.45,
                ),
          ),
        ],
        const SizedBox(height: 22),
        ...children,
        const SizedBox(height: 20),
      ],
    );
  }
}

Future<void> refreshContent() => ContentRepository.reload();

/// Quiet section label used across More/content pages.
class ContentSectionTitle extends StatelessWidget {
  final String title;

  const ContentSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              letterSpacing: -0.1,
            ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final String title;
  final String text;
  final IconData? icon;
  final Widget? trailing;

  const FeatureTile({
    super.key,
    required this.title,
    required this.text,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primarySoft.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                        height: 1.45,
                      ),
                ),
                if (trailing != null) ...[
                  const SizedBox(height: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact bottom CTA pair used on care info pages.
class ContentCtaRow extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const ContentCtaRow({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            onPressed: onPrimary,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size.fromHeight(46),
            ),
            child: Text(primaryLabel),
          ),
          if (secondaryLabel != null && onSecondary != null) ...[
            const SizedBox(height: 6),
            TextButton(
              onPressed: onSecondary,
              child: Text(secondaryLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
