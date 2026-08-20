import 'package:flutter_test/flutter_test.dart';
import 'package:orthoexpress_app/config/app_config.dart';
import 'package:orthoexpress_app/features/home/widgets/anatomy_embed_view.dart';
import 'package:orthoexpress_app/features/home/widgets/skeleton_stage.dart';

/// Covers the native side of the WebView embed without booting a platform
/// WebView, which unit tests cannot provide.
void main() {
  group('AnatomyBridgeMessage', () {
    test('routes book_appointment to the native booking screen', () {
      final message = AnatomyBridgeMessage.parse('book_appointment:knee_l');
      expect(message?.action, 'book_appointment');
      expect(message?.value, 'knee_l');
      expect(message?.route, '/more/book-appointment');
    });

    test('routes learn_more to the service detail screen', () {
      final message = AnatomyBridgeMessage.parse('learn_more:muscle-soft-tissue-care');
      expect(message?.route, '/services/muscle-soft-tissue-care');
    });

    test('reads selection changes and treats an empty value as cleared', () {
      final selected = AnatomyBridgeMessage.parse('select:shoulder_r');
      expect(selected?.isSelection, isTrue);
      expect(selected?.selectedId, 'shoulder_r');

      final cleared = AnatomyBridgeMessage.parse('select:');
      expect(cleared?.isSelection, isTrue);
      expect(cleared?.selectedId, isNull);
    });

    test('ignores blank and unknown messages', () {
      expect(AnatomyBridgeMessage.parse('   '), isNull);
      expect(AnatomyBridgeMessage.parse('something_else:1')?.route, isNull);
      expect(AnatomyBridgeMessage.parse('learn_more:')?.route, isNull);
    });
  });

  group('AppConfig.anatomyEmbedUri', () {
    test('requests the chrome-free stage for the given language', () {
      final uri = AppConfig.anatomyEmbedUri('es');
      expect(uri.path, '/embed/anatomy-viewer');
      expect(uri.queryParameters['lang'], 'es');
      expect(uri.queryParameters['mode'], 'stage');
    });

    test('falls back to English and can request the full page', () {
      final uri = AppConfig.anatomyEmbedUri('de', stageOnly: false);
      expect(uri.queryParameters['lang'], 'en');
      expect(uri.queryParameters.containsKey('mode'), isFalse);
    });
  });

  test('embed stays opt-in so tests and desktop use the native stage', () {
    expect(anatomyEmbedBuilder, isNull);
    expect(AppConfig.hasExplicitSiteUrl, isFalse);
  });
}
