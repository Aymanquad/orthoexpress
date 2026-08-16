import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../core/widgets/responsive_page.dart';
import '../../providers/language_provider.dart';
import 'widgets/home_sections.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    return RefreshIndicator(
      onRefresh: refreshContent,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            HomeHeroSection(),
            _Band(
              color: AppColors.bgWhite,
              padding: const EdgeInsets.only(top: 20),
              child: WhatWeTreatSection(),
            ),
            _Band(color: AppColors.bgLight, child: HowWeCareSection()),
            _Band(color: AppColors.bgWhite, child: LocationsPreviewSection()),
            _Band(color: AppColors.bgSoft, child: ReviewsSection()),
            _Band(color: AppColors.bgWhite, child: InsuranceSection()),
            _Band(color: AppColors.bgLight, child: BlogPreviewSection()),
          ],
        ),
      ),
    );
  }
}

class _Band extends StatelessWidget {
  final Color color;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _Band({
    required this.color,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ResponsivePage(child: child),
      ),
    );
  }
}
