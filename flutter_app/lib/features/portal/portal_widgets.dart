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
