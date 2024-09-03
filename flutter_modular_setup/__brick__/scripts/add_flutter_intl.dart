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

      // Find the position to insert the flutter_intl configuration
      final List<String> lines = contents.split('\n');
      int index = lines.lastIndexOf('flutter:');

      if (index != -1) {
        // Add flutter_intl under the flutter: tag
        lines.insert(index + 1, flutterIntlConfig.trim());
        pubspecFile.writeAsStringSync(lines.join('\n'));
        print(
            'Added flutter_intl configuration under flutter: tag in $dirPath/pubspec.yaml');
      } else {
        // If 'flutter:' tag is not found, append flutter_intl at the end
        pubspecFile.writeAsStringSync('\n$flutterIntlConfig',
            mode: FileMode.append);
        print(
            'Added flutter_intl configuration to the end of $dirPath/pubspec.yaml');
      }
    } else {
      print('File $dirPath/pubspec.yaml does not exist');
    }
  }
}
