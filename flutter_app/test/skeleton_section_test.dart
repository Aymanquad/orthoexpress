import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:orthoexpress_app/data/skeleton_joints.dart';
import 'package:orthoexpress_app/data/skeleton_labels.dart';
import 'package:orthoexpress_app/features/home/widgets/skeleton_viewer_section.dart';
import 'package:orthoexpress_app/providers/language_provider.dart';

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
}
