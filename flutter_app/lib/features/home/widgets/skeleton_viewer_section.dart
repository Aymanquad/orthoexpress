import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/responsive.dart';
import '../../../data/home_labels.dart';
import '../../../data/nav_labels.dart';
import '../../../data/skeleton_joints.dart';
import '../../../data/skeleton_labels.dart';
import '../../../providers/language_provider.dart';
import 'skeleton_stage.dart';

class SkeletonViewerSection extends StatefulWidget {
  const SkeletonViewerSection({super.key});

  @override
  State<SkeletonViewerSection> createState() => _SkeletonViewerSectionState();
}

class _SkeletonViewerSectionState extends State<SkeletonViewerSection> {
  String? _selectedId;

  double _stageHeight(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    if (width < 360) return 320;
    if (context.isPhone) {
      if (height < 680) return 340;
      if (height < 800) return 380;
      return 420;
    }
    if (width < 960) return 500;
    return 560;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final wide = context.screenWidth >= 960;
    final selected = _selectedId == null ? null : skeletonJointById(_selectedId!);
    final height = _stageHeight(context);

    return ColoredBox(
      color: const Color(0xFF070B18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF070B18), Color(0xFF0A1240), Color(0xFF070B18)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.pagePadding.left,
            context.isPhone ? 36 : 56,
            context.pagePadding.right,
            context.isPhone ? 40 : 56,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      SkeletonLabels.eyebrow.forLang(lang).toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF7EE0C8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      SkeletonLabels.title.forLang(lang),
                      style: GoogleFonts.sourceSerif4(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: context.isPhone ? 26 : 34,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      SkeletonLabels.subtitle.forLang(lang),
                      style: const TextStyle(
                        color: Color(0xC7E2E8FF),
                        fontSize: 15,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (wide)
                      _WideLayout(
                        lang: lang,
                        height: height,
                        selectedId: _selectedId,
                        selected: selected,
                        onSelect: (id) => setState(() => _selectedId = id),
                      )
                    else
                      _PhoneLayout(
                        lang: lang,
                        height: height,
                        selectedId: _selectedId,
                        selected: selected,
                        onSelect: (id) => setState(() => _selectedId = id),
                      ),
                    const SizedBox(height: 14),
                    Text(
                      SkeletonLabels.credit.forLang(lang),
                      style: const TextStyle(
                        color: Color(0x61E2E8FF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneLayout extends StatelessWidget {
  final String lang;
  final double height;
  final String? selectedId;
  final SkeletonJoint? selected;
  final ValueChanged<String?> onSelect;

  const _PhoneLayout({
    required this.lang,
    required this.height,
    required this.selectedId,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StageFrame(
          height: height,
          lang: lang,
          selectedId: selectedId,
          onSelect: onSelect,
        ),
        const SizedBox(height: 16),
        _Callout(lang: lang, selected: selected, onClose: () => onSelect(null)),
        const SizedBox(height: 14),
        _TopicList(lang: lang, selectedId: selectedId, onSelect: onSelect),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  final String lang;
  final double height;
  final String? selectedId;
  final SkeletonJoint? selected;
  final ValueChanged<String?> onSelect;

  const _WideLayout({
    required this.lang,
    required this.height,
    required this.selectedId,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 240,
            child: SingleChildScrollView(
              child: _Callout(
                lang: lang,
                selected: selected,
                onClose: () => onSelect(null),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _StageFrame(
              height: height,
              lang: lang,
              selectedId: selectedId,
              onSelect: onSelect,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 176,
            child: _TopicList(
              lang: lang,
              selectedId: selectedId,
              onSelect: onSelect,
              vertical: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageFrame extends StatelessWidget {
  final double height;
  final String lang;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  const _StageFrame({
    required this.height,
    required this.lang,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.isPhone ? 20 : 24);
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x0FFFFFFF), Color(0x05FFFFFF)],
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width;
              return Stack(
                fit: StackFit.expand,
                children: [
                  RepaintBoundary(
                    child: SkeletonStage(
                      canvasSize: Size(width, height),
                      allowOrbit: true,
                      selectedId: selectedId,
                      lang: lang,
                      onSelect: onSelect,
                    ),
                  ),
                  if (selectedId == null)
                    Positioned(
                      left: 14,
                      bottom: 12,
                      right: 14,
                      child: IgnorePointer(
                        child: Text(
                          (context.screenWidth >= 960
                                  ? SkeletonLabels.hintDesktop
                                  : SkeletonLabels.hintPhone)
                              .forLang(lang),
                          style: const TextStyle(
                            color: Color(0x80E2E8FF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  final String lang;
  final SkeletonJoint? selected;
  final VoidCallback onClose;

  const _Callout({
    required this.lang,
    required this.selected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (selected == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          SkeletonLabels.idle.forLang(lang),
          style: const TextStyle(
            color: Color(0x94E2E8FF),
            fontSize: 14,
            height: 1.55,
          ),
        ),
      );
    }

    final injuries = SkeletonLabels.injuries(selected!.region, lang);
    final treatment = SkeletonLabels.treatment(selected!.region, lang);

    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SkeletonLabels.panelKicker.forLang(lang).toUpperCase(),
            style: const TextStyle(
              color: Color(0xB8C4D2FF),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            SkeletonLabels.jointName(selected!.id, lang),
            style: GoogleFonts.sourceSerif4(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            SkeletonLabels.injuriesLabel.forLang(lang).toUpperCase(),
            style: const TextStyle(
              color: Color(0x7AE2E8FF),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          ...injuries.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(color: Color(0xD1E2E8FF)),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xD1E2E8FF),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            SkeletonLabels.treatmentLabel.forLang(lang).toUpperCase(),
            style: const TextStyle(
              color: Color(0x7AE2E8FF),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            treatment,
            style: const TextStyle(
              color: Color(0xC7E2E8FF),
              height: 1.55,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _PlainAction(
                label: HomeLabels.learnMore(lang),
                onPressed: () => context.push('/services/${selected!.slug}'),
              ),
              _PlainAction(
                label: NavLabels.bookAppointmentShort.forLang(lang),
                onPressed: () => context.push('/more/book-appointment'),
              ),
              _PlainAction(
                label: SkeletonLabels.close.forLang(lang),
                muted: true,
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlainAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool muted;

  const _PlainAction({
    required this.label,
    required this.onPressed,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: muted ? const Color(0x80E2E8FF) : Colors.white,
        textStyle: TextStyle(
          fontWeight: muted ? FontWeight.w500 : FontWeight.w600,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      ),
      child: Text(label),
    );
  }
}

class _TopicList extends StatelessWidget {
  final String lang;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final bool vertical;

  const _TopicList({
    required this.lang,
    required this.selectedId,
    required this.onSelect,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = skeletonTopics.map((topic) {
      final active = isTopicActive(topic.id, selectedId);
      return _TopicButton(
        label: SkeletonLabels.topicName(topic.id, lang),
        active: active,
        expanded: vertical,
        onPressed: () {
          final hotspot = primaryHotspotId(topic.id);
          if (hotspot == null) return;
          onSelect(active ? null : hotspot);
        },
      );
    }).toList();

    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items) item,
        ],
      );
    }

    return Wrap(spacing: 6, runSpacing: 6, children: items);
  }
}

class _TopicButton extends StatelessWidget {
  final String label;
  final bool active;
  final bool expanded;
  final VoidCallback onPressed;

  const _TopicButton({
    required this.label,
    required this.active,
    required this.onPressed,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(label);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: active ? Colors.white : const Color(0xADE2E8FF),
        backgroundColor: active ? const Color(0x12FFFFFF) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          decoration: TextDecoration.none,
        ),
      ),
      child: expanded ? Align(alignment: Alignment.centerLeft, child: text) : text,
    );
  }
}
