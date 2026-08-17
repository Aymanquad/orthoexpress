import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orthoexpress_app/core/widgets/app_bar_title.dart';

void main() {
  testWidgets('App bar title stays readable and ellipsizes instead of shrinking', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: _NarrowAppBar(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(FittedBox), findsNothing);

    final text = tester.widget<Text>(
      find.descendant(of: find.byType(AppBarTitle), matching: find.byType(Text)),
    );
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 1);
    expect(text.style?.fontSize, greaterThanOrEqualTo(AppBarTitle.minFontSize));

    final size = tester.getSize(find.byType(AppBarTitle));
    expect(size.height, greaterThanOrEqualTo(18));
  });
}

class _NarrowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _NarrowAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      title: const AppBarTitle('Patient Portal Sign In'),
      actions: const [
        IconButton(onPressed: null, icon: Icon(Icons.search)),
        IconButton(onPressed: null, icon: Icon(Icons.receipt_long)),
        IconButton(onPressed: null, icon: Icon(Icons.shopping_bag_outlined)),
      ],
    );
  }
}
