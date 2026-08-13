import 'package:flutter/material.dart';
import '../../config/theme.dart';

class AssetImageWithFallback extends StatelessWidget {
  final String assetPath;
  final String? fallbackPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AssetImageWithFallback({
    super.key,
    required this.assetPath,
    this.fallbackPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) {
        if (fallbackPath != null) {
          return Image.asset(
            fallbackPath!,
            fit: fit,
            width: width,
            height: height,
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

  const HeroImage({
    super.key,
    required this.assetPath,
    this.fallbackPath,
    this.height = 220,
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
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
