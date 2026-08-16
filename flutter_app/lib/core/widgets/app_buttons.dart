import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = _LabeledButton(
      filled: true,
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
    if (expanded) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = _LabeledButton(
      filled: false,
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
    if (expanded) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const OutlineButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class GhostCallButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool expanded;

  const GhostCallButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.65)),
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        overlayColor: Colors.white.withValues(alpha: 0.12),
      ),
      child: _ButtonBody(
        icon: Icons.phone_outlined,
        label: label,
      ),
    );
    if (expanded) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}

class _LabeledButton extends StatelessWidget {
  final bool filled;
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const _LabeledButton({
    required this.filled,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final body = _ButtonBody(icon: icon, label: label);
    if (filled) {
      return FilledButton(onPressed: onPressed, child: body);
    }
    return OutlinedButton(onPressed: onPressed, child: body);
  }
}

class _ButtonBody extends StatelessWidget {
  final IconData? icon;
  final String label;

  const _ButtonBody({this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 17),
        const SizedBox(width: 8),
        Flexible(child: text),
      ],
    );
  }
}
