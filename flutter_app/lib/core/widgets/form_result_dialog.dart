import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum FormDialogType { success, error, warning }

Future<void> showFormDialog(
  BuildContext context, {
  required FormDialogType type,
  required String title,
  required String message,
  required String primaryLabel,
  VoidCallback? onPrimary,
}) {
  final icon = switch (type) {
    FormDialogType.success => Icons.check_circle,
    FormDialogType.error => Icons.error_outline,
    FormDialogType.warning => Icons.warning_amber_rounded,
  };
  final iconColor = switch (type) {
    FormDialogType.success => AppColors.accent,
    FormDialogType.error => Colors.red.shade700,
    FormDialogType.warning => Colors.orange.shade700,
  };

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(icon, color: iconColor, size: 48),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onPrimary?.call();
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(primaryLabel),
        ),
      ],
    ),
  );
}

Future<void> showFormValidationDialog(
  BuildContext context, {
  required String title,
  required Map<String, String> errors,
  required String primaryLabel,
}) {
  final body = errors.values.join('\n');
  return showFormDialog(
    context,
    type: FormDialogType.warning,
    title: title,
    message: body,
    primaryLabel: primaryLabel,
  );
}
