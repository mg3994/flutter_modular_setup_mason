import 'dart:io';

void main() {
  final List<String> directories = [
    '{{project_name}}/shared/l10n',
    // '{{project_name}}/core',
    // '{{project_name}}/features/module1', // Add more directories as needed
    // '{{project_name}}/features/module2',
    // Add other directories as needed
  ];

  for (final dirPath in directories) {
    final Directory dir = Directory('$dirPath/lib/generated');

    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      print('Deleted $dirPath/lib/generated');
    } else {
      print('Directory $dirPath/lib/generated does not exist');
    }
  }
}
