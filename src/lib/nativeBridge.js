/**
 * Bridge to the Flutter WebView host.
 *
 * The native app registers a JavaScript channel named `FlutterBridge`. When the
 * page runs in a normal browser the channel is absent, so callers must fall back
 * to in-page routing.
 */
const CHANNEL = 'FlutterBridge'

export function hasNativeBridge() {
  if (typeof window === 'undefined') return false
  return typeof window[CHANNEL]?.postMessage === 'function'
}

export function postToNative(message) {
  if (!hasNativeBridge()) return false
  try {
    window[CHANNEL].postMessage(String(message))
    return true
  } catch (err) {
    console.warn('Native bridge post failed', err)
    return false
  }
}
