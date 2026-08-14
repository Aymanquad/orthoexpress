import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/accessibility_provider.dart';
import 'providers/language_provider.dart';

class OrthoExpressApp extends StatefulWidget {
  const OrthoExpressApp({super.key});

  @override
  State<OrthoExpressApp> createState() => _OrthoExpressAppState();
}

class _OrthoExpressAppState extends State<OrthoExpressApp> {
  /// Keep a single router for the app lifetime. Recreating it on language
  /// toggle remounts every mouse region and crashes Windows hit-testing.
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AccessibilityProvider>(
      builder: (context, lang, a11y, _) {
        final baseTheme = AppTheme.light(
          highContrast: a11y.highContrast,
          highlightLinks: a11y.highlightLinks,
        );

        return MaterialApp.router(
          title: 'OrthoExpress',
          debugShowCheckedModeBanner: false,
          theme: baseTheme,
          locale: lang.locale,
          supportedLocales: const [Locale('en'), Locale('es')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final baseScaler = MediaQuery.textScalerOf(context)
                .clamp(minScaleFactor: 0.9, maxScaleFactor: 1.25);
            final combinedScale = baseScaler.scale(1) * a11y.textScaleFactor;

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(combinedScale.clamp(0.85, 1.35)),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          routerConfig: _router,
        );
      },
    );
  }
}
