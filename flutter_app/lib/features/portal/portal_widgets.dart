import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../data/models/portal.dart';
import '../../data/portal_labels.dart';

String formatAppointmentWhen(PortalAppointment appt, String lang) {
  final scheduled = appt.scheduledAt;
  if (scheduled != null && scheduled.isNotEmpty) {
    final date = DateTime.tryParse(scheduled);
    if (date != null) {
      final locale = lang == 'es' ? 'es_US' : 'en_US';
      return DateFormat.yMMMEd(locale).add_jm().format(date.toLocal());
    }
    return scheduled;
  }
  final preferred = appt.preferredAt;
  if (preferred != null && preferred.isNotEmpty) return preferred;
  return '—';
}

class PortalStatusBadge extends StatelessWidget {
  final String status;
  final String lang;

  const PortalStatusBadge({super.key, required this.status, required this.lang});

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      'SCHEDULED' => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      'COMPLETED' => (const Color(0xFFF3F4F6), const Color(0xFF374151)),
      'CANCELLED' => (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      'NO_SHOW' => (const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
      _ => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        PortalLabels.status(status, lang),
        style: TextStyle(
          color: colors.$2,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class PortalRxStatusBadge extends StatelessWidget {
  final String status;
  final String lang;

  const PortalRxStatusBadge({super.key, required this.status, required this.lang});

  @override
  Widget build(BuildContext context) {
    final key = status.toUpperCase();
    final colors = switch (key) {
      'ACTIVE' => (const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
      'COMPLETED' => (const Color(0xFFF1F5F9), const Color(0xFF475569)),
      'DISCONTINUED' || 'STOPPED' => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
      _ => (const Color(0xFFF1F5F9), const Color(0xFF475569)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        PortalLabels.rxStatus(key, lang),
        style: TextStyle(
          color: colors.$2,
          fontWeight: FontWeight.w800,
          fontSize: 10,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class PortalInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool warn;
  final bool wide;

  const PortalInfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.warn = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warn ? const Color(0xFFFFF7ED) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warn ? const Color(0xFFFED7AA) : AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: warn ? const Color(0xFFFFEDD5) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: warn ? const Color(0xFFC2410C) : AppColors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (value == null || value!.trim().isEmpty) ? '—' : value!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!wide) return tile;
    return SizedBox(width: double.infinity, child: tile);
  }
}

class PortalRecordsCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget child;

  const PortalRecordsCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x141A237E)),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class PortalRxCard extends StatelessWidget {
  final Map<String, dynamic> rx;
  final String lang;

  const PortalRxCard({super.key, required this.rx, required this.lang});

  @override
  Widget build(BuildContext context) {
    final status = '${rx['status'] ?? ''}'.toUpperCase();
    final borderColor = switch (status) {
      'ACTIVE' => const Color(0xFFBAE6FD),
      'DISCONTINUED' || 'STOPPED' => const Color(0xFFFECACA),
      _ => AppColors.border,
    };
    final bg = switch (status) {
      'ACTIVE' => const Color(0xFFF0F9FF),
      'DISCONTINUED' || 'STOPPED' => const Color(0xFFFEF2F2),
      _ => Colors.white,
    };
    final dotColor = switch (status) {
      'ACTIVE' => const Color(0xFF0284C7),
      'DISCONTINUED' || 'STOPPED' => const Color(0xFFDC2626),
      _ => const Color(0xFF64748B),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: dotColor, width: 3),
                  ),
                ),
                Expanded(
                  child: Container(width: 2, color: AppColors.border.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${rx['medication'] ?? ''}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      PortalRxStatusBadge(status: status, lang: lang),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rx['dosage'] ?? ''}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (rx['frequency'] != null && '$rx[frequency]'.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${rx['frequency']}', style: const TextStyle(color: AppColors.textLight)),
                    ),
                  if (rx['instructions'] != null && '$rx[instructions]'.trim().isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(left: BorderSide(color: AppColors.accent, width: 3)),
                      ),
                      child: Text(
                        '${rx['instructions']}',
                        style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.4),
                      ),
                    ),
                  if (rx['prescribedBy'] != null && '$rx[prescribedBy]'.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${PortalLabels.provider.forLang(lang)}: ${rx['prescribedBy']}',
                        style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PortalAppointmentCard extends StatelessWidget {
  final PortalAppointment appointment;
  final String lang;
  final bool showReason;

  const PortalAppointmentCard({
    super.key,
    required this.appointment,
    required this.lang,
    this.showReason = false,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.serviceName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    appointment.locationName,
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${PortalLabels.date.forLang(lang)}: ${formatAppointmentWhen(appointment, lang)}',
                  ),
                  if (appointment.providerName != null && appointment.providerName!.isNotEmpty)
                    Text(
                      '${PortalLabels.provider.forLang(lang)}: ${appointment.providerName}',
                    ),
                  if (showReason && appointment.reason != null && appointment.reason!.isNotEmpty)
                    Text(
                      '${PortalLabels.reason.forLang(lang)}: ${appointment.reason}',
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PortalStatusBadge(status: appointment.status, lang: lang),
          ],
        ),
      ),
    );
  }
}
