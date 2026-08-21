import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/theme.dart';
import '../../data/clinic.dart';
import '../../data/doctor_labels.dart';
import '../../data/doctors.dart';
import '../../providers/language_provider.dart';

class DoctorCallScreen extends StatefulWidget {
  final String doctorId;

  const DoctorCallScreen({super.key, required this.doctorId});

  @override
  State<DoctorCallScreen> createState() => _DoctorCallScreenState();
}

class _DoctorCallScreenState extends State<DoctorCallScreen> {
  var _connected = false;
  var _seconds = 0;
  Timer? _connectTimer;
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _connectTimer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      setState(() => _connected = true);
      _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _seconds += 1);
      });
    });
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _tickTimer?.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _openDialer(Doctor doctor, String lang) async {
    final uri = Uri.parse(ClinicData.telLink(doctor.phone));
    final ok = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(DoctorLabels.callFailed.forLang(lang))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final doctor = doctorById(widget.doctorId);

    if (doctor == null) {
      return Center(
        child: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Doctor not found'),
        ),
      );
    }

    final status = _connected
        ? (lang == 'es' ? 'En llamada' : 'Connected')
        : (lang == 'es' ? 'Conectando…' : 'Connecting…');

    return ColoredBox(
      color: AppColors.primaryDark,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                child: Text(
                  doctor.monogram,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                doctor.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                doctor.specialty.forLang(lang),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 18),
              Text(
                status,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.accentLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_connected) ...[
                const SizedBox(height: 8),
                Text(
                  _timerLabel,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ],
              const Spacer(),
              Text(
                doctor.phone,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
                    ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _openDialer(doctor, lang),
                child: Text(
                  lang == 'es' ? 'Abrir marcador del teléfono' : 'Open phone dialer',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => context.pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                icon: const Icon(Icons.call_end_rounded),
                label: Text(lang == 'es' ? 'Finalizar' : 'End call'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
