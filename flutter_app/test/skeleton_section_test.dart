import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:orthoexpress_app/data/skeleton_joints.dart';
import 'package:orthoexpress_app/data/skeleton_labels.dart';
import 'package:orthoexpress_app/features/home/widgets/skeleton_viewer_section.dart';
import 'package:orthoexpress_app/providers/language_provider.dart';

/// Automated coverage for skeleton section UI flows that do not require the 3D engine.
///
/// Manual QA matrix (Windows + phone layout):
/// - Drag on model rotates via OrbitControls
/// - Tap hotspot selects joint and zooms camera
/// - Tap topic chip selects and zooms
/// - Tap same joint / Close deselects and resets camera
/// - Soft Tissue Learn More opens muscle-soft-tissue-care service page
void main() {
  testWidgets('Skeleton section shows injuries from topics without a 3D engine', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: SkeletonViewerSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Explore your injury on the body'), findsOneWidget);
    expect(find.text('Knee'), findsWidgets);

    await tester.ensureVisible(find.text('Knee').first);
    await tester.tap(find.text('Knee').first);
    await tester.pumpAndSettle();

    expect(find.text('COMMON INJURIES'), findsOneWidget);
    expect(find.text('ACL tears'), findsOneWidget);
    expect(find.textContaining('Sports and wear-and-tear'), findsOneWidget);
    expect(skeletonTopics, isNotEmpty);
    expect(SkeletonLabels.topicName('soft_tissue', 'en'), 'Muscle & Soft Tissue');
  });

  testWidgets('Soft tissue topic shows muscle service slug in callout actions', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: SkeletonViewerSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Muscle & Soft Tissue').first);
    await tester.tap(find.text('Muscle & Soft Tissue').first);
    await tester.pumpAndSettle();

    expect(find.text('COMMON INJURIES'), findsOneWidget);
    expect(find.textContaining('Tendonitis'), findsWidgets);

    final joint = skeletonJointById('soft_tissue');
    expect(joint?.slug, 'muscle-soft-tissue-care');
  });

  testWidgets('Wide layout exposes topic rail and idle copy', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: SkeletonViewerSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Neck'), findsOneWidget);
    expect(find.text('Shoulder'), findsOneWidget);
    expect(
      find.textContaining('Drag to rotate'),
      findsOneWidget,
    );
  });
}
