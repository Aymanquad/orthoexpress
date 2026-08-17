import 'package:flutter/material.dart';

/// App-bar title that stays readable: never shrinks below [_minFontSize],
/// then ellipsizes with an ellipsis if the remaining width is too tight.
class AppBarTitle extends StatelessWidget {
  static const double minFontSize = 15;
  static const double maxFontSize = 17;

  final String title;

  const AppBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).appBarTheme.titleTextStyle ??
        Theme.of(context).textTheme.titleLarge;
    final requested = base?.fontSize ?? maxFontSize;
    final fontSize = requested.clamp(minFontSize, maxFontSize);

    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      textAlign: TextAlign.start,
      style: (base ?? const TextStyle()).copyWith(
        fontSize: fontSize,
        height: 1.2,
      ),
    );
  }
}
