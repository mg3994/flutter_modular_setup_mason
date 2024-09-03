import 'dart:io';

Future<void> main() async {
  final directories = [
    'features',
    'shared',
    'core',
    'my_flutter_projecttts', // Replace with your actual project directory name if needed
  ];

  for (var dir in directories) {
    final path = Directory(dir);
    if (await path.exists()) {
      await for (var entity in path.list(recursive: true)) {
        if (entity is File && entity.uri.pathSegments.last == 'pubspec.yaml') {
          final content = await entity.readAsString();

          // Check if `publish_to` is already in the file
          if (!content.contains(RegExp(r'^publish_to:', multiLine: true))) {
            // Insert `publish_to: none` after the `name` field
            final lines = content.split('\n');
            final updatedLines = <String>[];

            bool addedPublishToNone = false;

            for (var line in lines) {
              updatedLines.add(line);
              if (line.startsWith('name:') && !addedPublishToNone) {
                updatedLines.add('publish_to: none');
                addedPublishToNone = true;
              }
            }

            // Write the updated content back to the file
            final updatedContent = updatedLines.join('\n');
            await entity.writeAsString(updatedContent);

            print('Updated ${entity.path}');
          } else {
            print('Skipped ${entity.path} (already contains publish_to)');
          }
        }
      }
    }
  }
}
