import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Centers page content and caps width on tablets / desktop (matches web container).
class ResponsivePage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool alignTop;

  const ResponsivePage({
    super.key,
    required this.child,
    this.padding,
    this.alignTop = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ?? context.pagePadding;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth > Breakpoints.maxContentWidth
        ? Breakpoints.maxContentWidth
        : screenWidth;

    return Align(
      alignment: alignTop ? Alignment.topCenter : Alignment.center,
      child: SizedBox(
        width: contentWidth,
        child: Padding(
          padding: resolvedPadding,
          child: child,
        ),
      ),
    );
  }
}

/// Scrollable page with responsive padding and max width.
class ResponsiveScrollPage extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const ResponsiveScrollPage({
    super.key,
    required this.children,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      child: ResponsivePage(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// Responsive grid for cards (locations, services on tablet).
class ResponsiveCardGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double spacing;
  final double runSpacing;

  const ResponsiveCardGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.listGridColumns;

    if (columns == 1) {
      return Column(
        children: List.generate(
          itemCount,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i < itemCount - 1 ? runSpacing : 0),
            child: itemBuilder(context, i),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final itemWidth = (maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: List.generate(itemCount, (i) {
            return SizedBox(
              width: itemWidth,
              child: itemBuilder(context, i),
            );
          }),
        );
      },
    );
  }
}
