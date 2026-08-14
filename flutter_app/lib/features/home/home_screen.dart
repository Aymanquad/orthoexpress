import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../core/widgets/responsive_page.dart';
import '../../providers/language_provider.dart';
import 'widgets/home_sections.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensures language rebuild on toggle.
    context.watch<LanguageProvider>();

    return RefreshIndicator(
      onRefresh: refreshContent,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeroSection(),
            ResponsivePage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  WhatWeTreatSection(),
                  HowWeCareSection(),
                  LocationsPreviewSection(),
                  ReviewsSection(),
                  InsuranceSection(),
                  BlogPreviewSection(),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
