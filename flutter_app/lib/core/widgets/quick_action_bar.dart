import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/theme.dart';
import '../../data/clinic.dart';
import '../../data/nav_labels.dart';
import '../../providers/language_provider.dart';

/// Persistent Call + Book strip for tab-root screens (mirrors web MobileActionBar).
class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return Material(
      color: AppColors.bgWhite,
      elevation: 6,
      shadowColor: AppColors.primary.withValues(alpha: 0.08),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(
                      ClinicData.telLink(ClinicData.headquartersPhone),
                    );
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: Text(NavLabels.call.forLang(lang)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/more/book-appointment'),
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: Text(NavLabels.book.forLang(lang)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
