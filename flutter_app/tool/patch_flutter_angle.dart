import 'dart:io';

/// Dart 3.9.0 crashes when a private `@Native` function is called with
/// `TypedData.address` (sdk#61321). flutter_angle 0.4.x hits that in
/// gles_bindings.dart. Making those natives public unblocks Windows builds.
void main() {
  final cache = Platform.environment['PUB_CACHE'] ??
      (Platform.isWindows
          ? '${Platform.environment['LOCALAPPDATA']}\\Pub\\Cache'
          : '${Platform.environment['HOME']}/.pub-cache');
  final hosted = Directory('$cache${Platform.pathSeparator}hosted');
  if (!hosted.existsSync()) {
    stderr.writeln('Pub cache not found at $cache');
    exit(1);
  }

  final files = hosted
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.replaceAll('\\', '/').endsWith(
            'flutter_angle-0.4.2/lib/src/desktop/gles_bindings.dart',
          ))
      .toList();

  if (files.isEmpty) {
    stderr.writeln('flutter_angle 0.4.2 gles_bindings.dart not found.');
    exit(1);
  }

  var changed = 0;
  for (final file in files) {
    final original = file.readAsStringSync();
    if (!original.contains('_glTyped')) {
      stdout.writeln('Already patched: ${file.path}');
      continue;
    }
    file.writeAsStringSync(original.replaceAll('_glTyped', 'glTyped'));
    stdout.writeln('Patched ${file.path}');
    changed += 1;
  }
  stdout.writeln('Patched $changed file(s).');
}
