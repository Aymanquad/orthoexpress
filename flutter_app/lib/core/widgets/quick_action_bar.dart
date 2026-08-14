import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../data/clinic.dart';
import '../../data/nav_labels.dart';

class QuickActionBar extends StatelessWidget {
  final VoidCallback? onBook;
  final bool compact;
  final String lang;

  const QuickActionBar({
    super.key,
    this.onBook,
    this.compact = false,
    required this.lang,
  });

  Future<void> _call() async {
    final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final verticalPadding = compact ? 8.0 : 10.0;
    final buttonPadding = compact ? 10.0 : 12.0;

    return Material(
      elevation: 4,
      color: AppColors.bgWhite,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _call,
                  icon: Icon(Icons.phone, size: compact ? 16 : 18),
                  label: Text(
                    compact ? NavLabels.call.forLang(lang) : NavLabels.callClinic.forLang(lang),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onBook,
                  icon: Icon(Icons.calendar_month, size: compact ? 16 : 18),
                  label: Text(
                    compact ? NavLabels.book.forLang(lang) : NavLabels.bookVisit.forLang(lang),
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: buttonPadding),
                    visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
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
