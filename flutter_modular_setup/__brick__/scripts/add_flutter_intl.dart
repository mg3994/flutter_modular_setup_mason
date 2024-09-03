import 'dart:io';

void main() {
  // Define the directories to be updated
  final List<String> directories = [
    '{{project_name}}/shared/l10n', // Add more directories as needed
    // Add other directories if necessary
  ];

  // Define the flutter_intl configuration to be added
  final String flutterIntlConfig = '''
flutter_intl:
  enabled: true
''';

  for (final dirPath in directories) {
    final File pubspecFile = File('$dirPath/pubspec.yaml');

    if (pubspecFile.existsSync()) {
      final String contents = pubspecFile.readAsStringSync();

      // Check if flutter_intl configuration already exists
      if (contents.contains('flutter_intl:')) {
        print(
            'flutter_intl configuration already exists in $dirPath/pubspec.yaml');
        continue;
      }

      // Append flutter_intl configuration at the end of the file
      pubspecFile.writeAsStringSync(
        '\n$flutterIntlConfig',
        mode: FileMode.append,
      );

      print(
          'Appended flutter_intl configuration to the end of $dirPath/pubspec.yaml');
    } else {
      print('File $dirPath/pubspec.yaml does not exist');
    }
  }
}
