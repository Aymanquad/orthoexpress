import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/home_labels.dart';
import '../../providers/language_provider.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return EmptyState(
      eyebrow: '404',
      icon: Icons.map_outlined,
      title: NotFoundLabels.title(lang),
      message: NotFoundLabels.text(lang),
      actionLabel: NotFoundLabels.goHome(lang),
      onAction: () => context.go('/home'),
    );
  }
}
