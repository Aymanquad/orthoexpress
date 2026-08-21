import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import 'widgets/home_dashboard_section.dart';
import 'widgets/home_sections.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();
    final auth = context.watch<PortalAuthProvider>();
    final signedIn = auth.isAuthenticated;
    final patientId = auth.patient?.id ?? 'guest';

    return RefreshIndicator(
      onRefresh: refreshContent,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: signedIn
            ? Column(
                key: ValueKey('home-in-$patientId'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Band(
                    color: AppColors.bgWhite,
                    child: HomeDashboardSection(key: ValueKey('dash-$patientId')),
                  ),
                  const _Band(color: AppColors.bgLight, child: WhatWeTreatSection()),
                  const _Band(
                    color: AppColors.bgWhite,
                    child: LocationsPreviewSection(compact: true),
                  ),
                ],
              )
            : const Column(
                key: ValueKey('home-guest'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeroSection(),
                  _Band(
                    color: AppColors.bgWhite,
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: _GuestSignInPrompt(),
                  ),
                  _Band(
                    color: AppColors.bgWhite,
                    padding: EdgeInsets.only(top: 8),
                    child: WhatWeTreatSection(),
                  ),
                  _Band(
                    color: AppColors.bgWhite,
                    child: LocationsPreviewSection(compact: true),
                  ),
                  _Band(color: AppColors.bgSoft, child: ReviewsSection(compact: true)),
                  _Band(color: AppColors.bgWhite, child: InsuranceSection()),
                ],
              ),
      ),
    );
  }
}

/// Soft prompt — not a hard gate. Guest can keep browsing.
class _GuestSignInPrompt extends StatelessWidget {
  const _GuestSignInPrompt();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      color: AppColors.primarySoft,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/more/portal/login'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.phone_android_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PortalLabels.signInPromptTitle.forLang(lang),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      PortalLabels.signInPromptBody.forLang(lang),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                PortalLabels.signInPromptCta.forLang(lang),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.accent, size: 18),
            ],
          ),
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
