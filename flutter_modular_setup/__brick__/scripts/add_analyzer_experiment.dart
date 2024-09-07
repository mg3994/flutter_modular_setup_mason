//in use and working
import 'dart:io';

Future<void> main() async {
  final directories = [
    'features',
    'shared',
    'core',
    '{{project_name}}', // Replace with your actual project directory name if needed
  ];

  for (var dir in directories) {
    final path = Directory(dir);
    if (await path.exists()) {
      await for (var entity in path.list(recursive: true)) {
        if (entity is File &&
            entity.uri.pathSegments.last == 'analysis_options.yaml') {
          final content = await entity.readAsString();

          // Check if `analyzer` is already in the file
          if (!content.contains(RegExp(r'^analyzer:', multiLine: true))) {
            // Add the analyzer experiment configuration at the end of the file
            final updatedContent = '''
$content

analyzer:
  enable-experiment:
    - macros
''';
            await entity.writeAsString(updatedContent);
            print('Updated ${entity.path}');
          } else if (!content.contains('enable-experiment:')) {
            // If `analyzer` exists but `enable-experiment` is not present
            final lines = content.split('\n');
            final updatedLines = <String>[];

            bool addedExperiment = false;

            for (var line in lines) {
              updatedLines.add(line);
              if (line.startsWith('analyzer:') && !addedExperiment) {
                updatedLines.add('  enable-experiment:');
                updatedLines.add('    - macros');
                addedExperiment = true;
              }
            }

            // Write the updated content back to the file
            final updatedContent = updatedLines.join('\n');
            await entity.writeAsString(updatedContent);

            print('Updated ${entity.path}');
          } else {
            print(
                'Skipped ${entity.path} (already contains enable-experiment for macros)');
          }
        }
      }
    }
  }
}
