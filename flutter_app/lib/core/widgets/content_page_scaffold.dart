import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'responsive_page.dart';

class ContentPageScaffold extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? lead;
  final List<Widget> children;

  const ContentPageScaffold({
    super.key,
    this.eyebrow,
    required this.title,
    this.lead,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsivePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (eyebrow != null) ...[
              Text(
                eyebrow!.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            Text(title, style: Theme.of(context).textTheme.displaySmall),
            if (lead != null) ...[
              const SizedBox(height: 8),
              Text(
                lead!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textLight,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            ...children,
            const SizedBox(height: 24),
          ],
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(text),
                  if (trailing != null) ...[
                    const SizedBox(height: 8),
                    trailing!,
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
