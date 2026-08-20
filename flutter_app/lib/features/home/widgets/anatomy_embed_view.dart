import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../config/app_config.dart';
import '../../../data/skeleton_labels.dart';
import 'skeleton_stage.dart';

/// `webview_flutter` only ships Android and iOS implementations, so desktop
/// builds keep using the native `three_js` viewer.
bool get anatomyEmbedSupported =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Opt the home skeleton stage into the embedded web viewer. Called from
/// `main.dart` so widget tests never construct a platform WebView.
void registerAnatomyEmbed() {
  // A physical phone cannot reach 10.0.2.2. Until a real SITE_URL is set,
  // keep the bundled three_js viewer so the skeleton is actually visible.
  if (!anatomyEmbedSupported || !AppConfig.hasExplicitSiteUrl) return;
  anatomyEmbedBuilder =
      ({
        Key? key,
        required String lang,
        required String? selectedId,
        required ValueChanged<String?> onSelect,
        required ValueChanged<String> onNavigate,
      }) {
        return AnatomyEmbedView(
          key: key,
          lang: lang,
          selectedId: selectedId,
          onSelect: onSelect,
          onNavigate: onNavigate,
        );
      };
}

const _embedBackground = Color(0xFF070B18);

/// How long the viewer may stay off-screen before its WebView is torn down.
/// Long enough to survive incidental scrolling, short enough to release the
/// WebGL context and the ~13 MB model when the user actually leaves.
const _teardownDelay = Duration(seconds: 12);

final _safeId = RegExp(r'^[A-Za-z0-9_-]+$');

/// Parsed `FlutterBridge` message sent by the embedded web viewer.
@immutable
class AnatomyBridgeMessage {
  final String action;
  final String value;

  const AnatomyBridgeMessage(this.action, this.value);

  static AnatomyBridgeMessage? parse(String raw) {
    final message = raw.trim();
    if (message.isEmpty) return null;
    final separator = message.indexOf(':');
    if (separator < 0) return AnatomyBridgeMessage(message, '');
    return AnatomyBridgeMessage(
      message.substring(0, separator),
      message.substring(separator + 1),
    );
  }

  bool get isSelection => action == 'select';

  /// Hotspot id for a `select:` message; null clears the selection.
  String? get selectedId => value.isEmpty ? null : value;

  /// Flutter shell route this message opens, or null when unsupported.
  String? get route {
    switch (action) {
      case 'book_appointment':
        return '/more/book-appointment';
      case 'learn_more':
        return value.isEmpty ? null : '/services/$value';
      default:
        return null;
    }
  }
}

/// Embeds the website's skeleton viewer (`/embed/anatomy-viewer`) so the app
/// reuses the proven Three.js scene instead of re-implementing it natively.
class AnatomyEmbedView extends StatefulWidget {
  final String lang;

  /// Hotspot the native callout is showing, mirrored into the web scene.
  final String? selectedId;

  /// Fired when a joint is tapped inside the web scene.
  final ValueChanged<String?> onSelect;

  /// Called with the Flutter shell route a bridge message resolves to.
  final ValueChanged<String> onNavigate;

  const AnatomyEmbedView({
    super.key,
    required this.lang,
    required this.selectedId,
    required this.onSelect,
    required this.onNavigate,
  });

  @override
  State<AnatomyEmbedView> createState() => _AnatomyEmbedViewState();
}

class _AnatomyEmbedViewState extends State<AnatomyEmbedView> {
  final _visibilityKey = UniqueKey();

  WebViewController? _controller;
  Timer? _teardownTimer;
  bool _loading = true;
  bool _failed = false;

  /// Last selection echoed from the web scene, so mirroring it back is skipped.
  String? _webSelection;

  @override
  void didUpdateWidget(covariant AnatomyEmbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lang != widget.lang) _syncLanguage();
    if (oldWidget.selectedId != widget.selectedId) _syncSelection();
  }

  @override
  void dispose() {
    _teardownTimer?.cancel();
    _controller = null;
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction > 0.05) {
      _teardownTimer?.cancel();
      _teardownTimer = null;
      if (_controller == null && !_failed) _createController();
      return;
    }
    if (_controller == null || _teardownTimer != null) return;
    _teardownTimer = Timer(_teardownDelay, _teardown);
  }

  void _teardown() {
    _teardownTimer = null;
    final controller = _controller;
    if (controller == null || !mounted) return;
    // Drop the page first so the GPU context and model bytes are released.
    controller.loadRequest(Uri.parse('about:blank'));
    _webSelection = null;
    setState(() {
      _controller = null;
      _loading = true;
    });
  }

  void _createController() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(_embedBackground)
      ..enableZoom(false)
      ..addJavaScriptChannel('FlutterBridge', onMessageReceived: _onBridgeMessage)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loading = false);
            // Replay a selection made while the scene was still loading.
            _syncSelection();
          },
          onWebResourceError: (error) {
            // A failed texture or font must not blank the whole viewer.
            if (error.isForMainFrame == false) return;
            if (mounted) {
              setState(() {
                _failed = true;
                _loading = false;
              });
            }
          },
          onNavigationRequest: _onNavigationRequest,
        ),
      );

    setState(() {
      _controller = controller;
      _loading = true;
    });
    controller.loadRequest(AppConfig.anatomyEmbedUri(widget.lang));
  }

  void _onBridgeMessage(JavaScriptMessage message) {
    final parsed = AnatomyBridgeMessage.parse(message.message);
    if (parsed == null || !mounted) return;

    if (parsed.isSelection) {
      _webSelection = parsed.selectedId;
      widget.onSelect(parsed.selectedId);
      return;
    }

    final route = parsed.route;
    if (route != null) widget.onNavigate(route);
  }

  void _syncSelection() {
    final controller = _controller;
    if (controller == null) return;
    final selected = widget.selectedId;
    if (selected == _webSelection) return;
    // Hotspot ids are injected into a JS call, so keep them to a safe alphabet.
    if (selected != null && !_safeId.hasMatch(selected)) return;
    final arg = selected == null ? 'null' : "'$selected'";
    controller.runJavaScript(
      'window.OrthoEmbed && window.OrthoEmbed.select'
      ' && window.OrthoEmbed.select($arg);',
    );
  }

  /// Keeps the WebView pinned to the embed page; other links become native
  /// navigation so site chrome never appears inside the app.
  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final target = Uri.tryParse(request.url);
    if (target == null) return NavigationDecision.prevent;
    if (target.path.startsWith('/embed/') || target.path == 'blank') {
      return NavigationDecision.navigate;
    }
    if (target.scheme == 'about') return NavigationDecision.navigate;

    final route = _routeForWebPath(target.path);
    if (route != null && mounted) widget.onNavigate(route);
    return NavigationDecision.prevent;
  }

  String? _routeForWebPath(String path) {
    if (path.startsWith('/services/')) return path;
    if (path == '/book-appointment') return '/more/book-appointment';
    return null;
  }

  void _syncLanguage() {
    final controller = _controller;
    if (controller == null) return;
    final lang = widget.lang == 'es' ? 'es' : 'en';
    // Prefer the in-page setter so switching language keeps the loaded model.
    controller.runJavaScript(
      "window.OrthoEmbed && window.OrthoEmbed.setLang"
      " ? window.OrthoEmbed.setLang('$lang')"
      " : window.location.replace('/embed/anatomy-viewer?lang=$lang');",
    );
  }

  void _retry() {
    setState(() {
      _failed = false;
      _controller = null;
    });
    _createController();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: ColoredBox(
        color: _embedBackground,
        child: _failed
            ? _EmbedError(lang: widget.lang, onRetry: _retry)
            : Stack(
                fit: StackFit.expand,
                children: [
                  if (controller != null)
                    WebViewWidget(
                      controller: controller,
                      // Horizontal drags rotate the model; vertical drags stay
                      // with the page so the home feed still scrolls.
                      gestureRecognizers: {
                        Factory<HorizontalDragGestureRecognizer>(
                          HorizontalDragGestureRecognizer.new,
                        ),
                        Factory<TapGestureRecognizer>(TapGestureRecognizer.new),
                      },
                    ),
                  if (_loading) _EmbedLoading(lang: widget.lang),
                ],
              ),
      ),
    );
  }
}

class _EmbedLoading extends StatelessWidget {
  final String lang;

  const _EmbedLoading({required this.lang});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ColoredBox(
        color: _embedBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Color(0xFFC4D2FF),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              SkeletonLabels.loading.forLang(lang),
              style: const TextStyle(color: Color(0xE6EEF2FF), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmbedError extends StatelessWidget {
  final String lang;
  final VoidCallback onRetry;

  const _EmbedError({required this.lang, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0C1650),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SkeletonLabels.error.forLang(lang),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xCCEEF2FF)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text(SkeletonLabels.retry.forLang(lang)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
