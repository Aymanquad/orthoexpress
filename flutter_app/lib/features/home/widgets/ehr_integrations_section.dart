import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../data/ehrs.dart';
import '../../../data/home_labels.dart';
import '../../../providers/language_provider.dart';

/// Native PageView carousel mirroring the web EHR integrations section.
class EhrIntegrationsSection extends StatefulWidget {
  const EhrIntegrationsSection({super.key});

  @override
  State<EhrIntegrationsSection> createState() => _EhrIntegrationsSectionState();
}

class _EhrIntegrationsSectionState extends State<EhrIntegrationsSection> {
  static const _autoMs = Duration(milliseconds: 4200);

  late final PageController _controller;
  double _page = 0;
  Timer? _timer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.72);
    _controller.addListener(_onScroll);
    _startAuto();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final page = _controller.page;
    if (page == null) return;
    setState(() => _page = page);
  }

  void _startAuto() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoMs, (_) {
      if (!mounted || _paused || !_controller.hasClients) return;
      final next = (_page.round() + 1) % ehrSystems.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _pause() {
    if (_paused) return;
    setState(() => _paused = true);
  }

  void _resume() {
    if (!_paused) return;
    setState(() => _paused = false);
    _startAuto();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final index = _page.round().clamp(0, ehrSystems.length - 1);
    final active = ehrSystems[index];

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 28),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
                  ),
                  child: Text(
                    HomeLabels.ehrEyebrow(lang).toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  HomeLabels.ehrTitle(lang),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSerif4(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    letterSpacing: -0.4,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  HomeLabels.ehrSubtitle(lang),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                        height: 1.55,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Listener(
            onPointerDown: (_) => _pause(),
            onPointerUp: (_) => _resume(),
            onPointerCancel: (_) => _resume(),
            child: SizedBox(
              height: 286,
              child: PageView.builder(
                controller: _controller,
                itemCount: ehrSystems.length,
                onPageChanged: (i) {
                  setState(() => _page = i.toDouble());
                  if (!_paused) _startAuto();
                },
                itemBuilder: (context, i) {
                  final distance = (_page - i).abs().clamp(0.0, 1.0);
                  final scale = 1 - (distance * 0.12);
                  final opacity = 1 - (distance * 0.38);
                  final ehr = ehrSystems[i];
                  final isActive = distance < 0.35;

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: _EhrCard(
                          ehr: ehr,
                          lang: lang,
                          isActive: isActive,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Padding(
              key: ValueKey(active.id),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                active.highlight.forLang(lang),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                      height: 1.55,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${index + 1} / ${ehrSystems.length}',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          _ProgressBar(
            key: ValueKey('${active.id}-$_paused'),
            paused: _paused,
            duration: _autoMs,
          ),
        ],
      ),
    );
  }
}

class _EhrCard extends StatelessWidget {
  final EhrSystem ehr;
  final String lang;
  final bool isActive;

  const _EhrCard({
    required this.ehr,
    required this.lang,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isActive ? 0.14 : 0.07),
            blurRadius: isActive ? 28 : 16,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE8EAF6),
                            Color(0xFFDCE0F5),
                            Color(0xFFE6F6EF),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isActive)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      width: isActive ? 84 : 72,
                      height: isActive ? 84 : 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isActive ? 24 : 20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF121A6B),
                            Color(0xFF1A237E),
                            Color(0xFF283593),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF121A6B).withValues(alpha: 0.3),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        ehr.monogram,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: isActive ? 20 : 17,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.primary.withValues(alpha: 0.06)),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    ehr.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: isActive ? 16 : 14.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isActive ? AppColors.primary : AppColors.textDark,
                      height: 1.25,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 6),
                    Text(
                      ehr.developer,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        ehr.country.forLang(lang).toUpperCase(),
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatefulWidget {
  final bool paused;
  final Duration duration;

  const _ProgressBar({
    super.key,
    required this.paused,
    required this.duration,
  });

  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (!widget.paused) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.paused) {
      _controller.stop();
    } else if (!_controller.isAnimating && _controller.value < 1) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return LinearProgressIndicator(
              value: _controller.value,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 2,
            );
          },
        ),
      ),
    );
  }
}
