import 'dart:io';

void main() {
  final rootDependencies = '''
  # ------------- Core Modules ----------------
  packages:
    path: shared/packages
  preferences:
    path: shared/preferences
  components:
    path: shared/components
  core:
    path: core

  # ------------- Basic Every App Feature Module ----------------
  themer:
    path: features/themer
  updater:
    path: features/updater
  l10nr:
    path: features/l10nr
''';

  final coreDependencies = '''
dependencies:
  packages:
    path: ../shared/packages
  preferences:
    path: ../shared/preferences
''';

  final featureDependencies = '''
dependencies:
  flutter:
    sdk: flutter
  packages:
    path: ../../shared/packages
  core:
    path: ../../core
''';

  final devDependencies = '''
dev_dependencies:
  flutter_lints: ^4.0.0
  bloc_test:
  json_serializable:
  freezed:
  build_runner:
''';

  final componentsDependencies = '''
dependencies:
  packages:
    path: ../packages
  core:
    path: ../../core
''';

  final l10nrDependencies = '''
dependencies:
  flutter_localizations:
    sdk: flutter
  intl:
  packages:
    path: ../packages
''';

  final l10nrFlutterIntlConfig = '''
flutter_intl:
  enabled: true
  class_name: AppLocalizations
''';

  final preferencesDependencies = '''
dependencies:
  packages:
    path: ../packages
''';

  final packagesDependencies = '''
dependencies:
  _macros:
    sdk: dart
  cupertino_icons:
  web:
  connectivity_plus:
  dio:
  json_annotation:
  freezed_annotation:
  dartz:
  flutter_bloc:
  intl:
  get_it:
  hive_flutter: ^2.0.0-dev
  l10n:
    path: ../l10n
''';

  updatePubspecFile('pubspec.yaml', rootDependencies, devDependencies);
  updatePubspecFile('core/pubspec.yaml', coreDependencies);
  updatePubspecFile(
      'features/themer/pubspec.yaml', featureDependencies, devDependencies);
  updatePubspecFile(
      'features/updater/pubspec.yaml', featureDependencies, devDependencies);
  updatePubspecFile(
      'features/l10nr/pubspec.yaml', l10nrDependencies, l10nrFlutterIntlConfig);
  updatePubspecFile('shared/components/pubspec.yaml', componentsDependencies);
  updatePubspecFile('shared/preferences/pubspec.yaml', preferencesDependencies);
  updatePubspecFile('shared/packages/pubspec.yaml', packagesDependencies);
}

void updatePubspecFile(String path, String dependencies,
    [String? additionalContent]) {
  final file = File(path);
  if (!file.existsSync()) {
    print('Error: $path not found.');
    return;
  }

  final content = file.readAsStringSync();
  final newContent = StringBuffer();

  if (!content.contains(dependencies.trim().split('\n').first)) {
    newContent.write(dependencies);
    newContent.write('\n');
  }

  newContent.write(content);

  if (additionalContent != null &&
      !content.contains(additionalContent.trim().split('\n').first)) {
    newContent.write('\n');
    newContent.write(additionalContent);
  }

  file.writeAsStringSync(newContent.toString());
  print('Updated $path successfully.');
}
