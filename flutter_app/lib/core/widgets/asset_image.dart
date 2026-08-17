import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AssetImageWithFallback extends StatelessWidget {
  final String assetPath;
  final String? fallbackPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;

  const AssetImageWithFallback({
    super.key,
    required this.assetPath,
    this.fallbackPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      errorBuilder: (_, __, ___) {
        if (fallbackPath != null) {
          return Image.asset(
            fallbackPath!,
            fit: fit,
            width: width,
            height: height,
            alignment: alignment,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
        }
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.bgSoft,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32),
    );
  }
}

class HeroImage extends StatelessWidget {
  final String assetPath;
  final String? fallbackPath;
  final double height;
  final Alignment alignment;
  final Gradient? overlay;

  const HeroImage({
    super.key,
    required this.assetPath,
    this.fallbackPath,
    this.height = 220,
    this.alignment = Alignment.center,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: AssetImageWithFallback(
              assetPath: assetPath,
              fallbackPath: fallbackPath,
              fit: BoxFit.cover,
              alignment: alignment,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: overlay ??
                  LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-bleed inner-page hero with overlay copy and a compact green book CTA.
/// Copy sits above the button so the two never overlap on phones.
class PageHeroBanner extends StatelessWidget {
  final String assetPath;
  final String? fallbackPath;
  final double minHeight;
  final Alignment alignment;
  final Widget? content;
  final String? bookLabel;
  final VoidCallback? onBook;

  const PageHeroBanner({
    super.key,
    required this.assetPath,
    this.fallbackPath,
    this.minHeight = 280,
    this.alignment = Alignment.center,
    this.content,
    this.bookLabel,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final showBook = onBook != null && (bookLabel?.isNotEmpty ?? false);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Stack(
        children: [
          Positioned.fill(
            child: AssetImageWithFallback(
              assetPath: assetPath,
              fallbackPath: fallbackPath,
              fit: BoxFit.cover,
              alignment: alignment,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Color(0x99000000),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, showBook ? 58 : 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: content ?? const SizedBox.shrink(),
            ),
          ),
          if (showBook)
            Positioned(
              right: 12,
              bottom: 12,
              child: AccentHeroBookButton(
                label: bookLabel!,
                onPressed: onBook,
              ),
            ),
        ],
      ),
    );
  }
}

class AccentHeroBookButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool compact;

  const AccentHeroBookButton({
    super.key,
    required this.label,
    this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: Size(0, compact ? 34 : 38),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 14,
          vertical: compact ? 7 : 8,
        ),
        shape: const StadiumBorder(),
        elevation: 2,
        shadowColor: AppColors.accent.withValues(alpha: 0.4),
        textStyle: TextStyle(
          fontSize: compact ? 12 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: compact ? 5 : 7),
          Icon(Icons.arrow_forward_rounded, size: compact ? 13 : 15),
        ],
      ),
    );
  }
}
