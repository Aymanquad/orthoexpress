import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/language_provider.dart';

class OrthoExpressApp extends StatelessWidget {
  const OrthoExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    return Consumer<LanguageProvider>(
      builder: (context, lang, _) {
        return MaterialApp.router(
          title: 'OrthoExpress',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: lang.locale,
          supportedLocales: const [Locale('en'), Locale('es')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final scaler = MediaQuery.textScalerOf(context)
                .clamp(minScaleFactor: 0.9, maxScaleFactor: 1.25);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: scaler),
              child: child ?? const SizedBox.shrink(),
            );
          },
          routerConfig: router,
        );
      },
    );
  }
}
