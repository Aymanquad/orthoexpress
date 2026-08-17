import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../providers/language_provider.dart';

/// Compact English | Spanish language chip — matches the web header toggle.
class LanguageChip extends StatelessWidget {
  const LanguageChip({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isEs = lang.isSpanish;
    final compact = context.isPhone;

    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Semantics(
        button: true,
        label: isEs
            ? 'Idioma: Spanish. Cambiar a English'
            : 'Language: English. Switch to Spanish',
        child: Material(
          color: AppColors.primarySoft.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => lang.toggle());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Seg(label: compact ? 'EN' : 'English', active: !isEs),
                  _Seg(label: compact ? 'ES' : 'Spanish', active: isEs),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Seg extends StatelessWidget {
  final String label;
  final bool active;

  const _Seg({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: active ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
