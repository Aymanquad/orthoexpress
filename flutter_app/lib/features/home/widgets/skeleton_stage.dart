import 'package:flutter/material.dart';

import '../../../data/skeleton_labels.dart';

typedef SkeletonStageBuilder =
    Widget Function({
      Key? key,
      required Size canvasSize,
      required bool allowOrbit,
      required String? selectedId,
      required String lang,
      required ValueChanged<String?> onSelect,
    });

/// Set from `main.dart` so widget tests never import the FFI 3D engine.
SkeletonStageBuilder? skeletonStageBuilder;

class SkeletonStage extends StatelessWidget {
  final Size canvasSize;
  final bool allowOrbit;
  final String? selectedId;
  final String lang;
  final ValueChanged<String?> onSelect;

  const SkeletonStage({
    super.key,
    required this.canvasSize,
    required this.allowOrbit,
    required this.selectedId,
    required this.lang,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final builder = skeletonStageBuilder;
    if (builder == null) {
      return ColoredBox(
        color: const Color(0xFF0C1650),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              SkeletonLabels.idle.forLang(lang),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xCCEEF2FF)),
            ),
          ),
        ),
      );
    }
    return builder(
      key: key,
      canvasSize: canvasSize,
      allowOrbit: allowOrbit,
      selectedId: selectedId,
      lang: lang,
      onSelect: onSelect,
    );
  }
}
