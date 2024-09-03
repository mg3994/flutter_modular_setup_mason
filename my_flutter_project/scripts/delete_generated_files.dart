import 'dart:io';

void main() {
  final List<String> directories = [
    'my_flutter_projecttts/shared/l10n',
    // 'my_flutter_projecttts/core',
    // 'my_flutter_projecttts/features/module1', // Add more directories as needed
    // 'my_flutter_projecttts/features/module2',
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
