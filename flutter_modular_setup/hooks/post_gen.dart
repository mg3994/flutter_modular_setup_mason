// import 'dart:io';
// import 'package:mason/mason.dart';

// Future<String> findFlutterPath() async {
//   final command = Platform.isWindows ? 'where flutter' : 'which flutter';

//   final result = await Process.run(command, [], runInShell: true);

//   if (result.exitCode == 0) {
//     final paths = result.stdout.split('\n').map((e) => e.trim()).toList();

//     if (Platform.isWindows) {
//       // On Windows, prioritize .bat file if available
//       for (var path in paths) {
//         if (path.endsWith('.bat')) {
//           return path;
//         }
//       }
//       // Fallback to first path if no .bat file found
//       return paths.first;
//     } else {
//       // On non-Windows systems, just return the first path
//       return paths.first;
//     }
//   } else {
//     throw Exception('Unable to find Flutter executable: ${result.stderr}');
//   }
// }

// void run(HookContext context) async {
//   final projectName = context.vars['project_name'];
//   final orgName = context.vars['org_name'];
//   final projectDirectory = Directory(projectName);

//   // Create the project directory if it doesn't exist
//   if (!projectDirectory.existsSync()) {
//     projectDirectory.createSync(recursive: true);
//   }

//   context.logger.info('Finding Flutter executable...');

//   // Find the path to the Flutter executable
//   final flutterPath = await findFlutterPath();

//   context.logger.info('Configuring Flutter platforms...');

//   // Enable or disable Flutter platforms
//   final platforms = [
//     'enable-web',
//     'enable-linux-desktop',
//     'enable-macos-desktop',
//     'enable-windows-desktop',
//     'enable-android',
//     'enable-ios',
//     'enable-fuchsia',
//     'enable-custom-devices',
//     'enable-swift-package-manager',
//   ];

//   for (var platform in platforms) {
//     final result = await Process.run(flutterPath, ['config', '--$platform'],
//         environment: {
//           'PATH': Platform.environment['PATH'] ?? '',
//         },
//         runInShell: true);

//     if (result.exitCode != 0) {
//       context.logger.err('Failed to configure $platform: ${result.stderr}');
//     } else {
//       context.logger.info('$platform configured successfully.');
//     }
//   }

//   context.logger.info('Creating Flutter project with --overwrite flag...');

//   // Run the flutter create command
//   final result = await Process.run(flutterPath,
//       ['create', '--org', orgName, projectName, '--overwrite', '-e'],
//       environment: {
//         'PATH': Platform.environment['PATH'] ?? '',
//       },
//       runInShell: true);

//   if (result.exitCode != 0) {
//     context.logger.err('Failed to create project: ${result.stderr}');
//     return;
//   }

//   context.logger.info('Project created successfully!');

//   // Change directory to the project directory
//   Directory.current = projectDirectory;

//   // Create core package
//   Process.runSync(
//       flutterPath, ['create', '--org', orgName, '-t', 'package', 'core'],
//       environment: {
//         'PATH': Platform.environment['PATH'] ?? '',
//       },
//       runInShell: true);

//   // Create features packages
//   final features = ['updater', 'themer', 'l10nr'];
//   for (var feature in features) {
//     Process.runSync(flutterPath,
//         ['create', '--org', orgName, '-t', 'package', 'features/$feature'],
//         environment: {
//           'PATH': Platform.environment['PATH'] ?? '',
//         },
//         runInShell: true);
//   }

//   // Create shared packages
//   final sharedPackages = ['preferences', 'i10n', 'packages', 'components'];
//   for (var sharedPackage in sharedPackages) {
//     Process.runSync(flutterPath,
//         ['create', '--org', orgName, '-t', 'package', 'shared/$sharedPackage'],
//         environment: {
//           'PATH': Platform.environment['PATH'] ?? '',
//         },
//         runInShell: true);
//   }

//   context.logger.info('Modular Flutter project generated successfully!');
// }

import 'dart:io';
import 'package:mason/mason.dart';

Future<String> findFlutterPath() async {
  final command = Platform.isWindows ? 'where flutter' : 'which flutter';

  final result = await Process.run(command, [], runInShell: true);

  if (result.exitCode == 0) {
    final paths = result.stdout.split('\n').map((e) => e.trim()).toList();

    if (Platform.isWindows) {
      for (var path in paths) {
        if (path.endsWith('.bat')) {
          return path;
        }
      }
      return paths.first;
    } else {
      return paths.first;
    }
  } else {
    throw Exception('Unable to find Flutter executable: ${result.stderr}');
  }
}

void run(HookContext context) async {
  final projectName = context.vars['project_name'];
  final orgName = context.vars['org_name'];
  final projectDirectory = Directory(projectName);

  if (!projectDirectory.existsSync()) {
    projectDirectory.createSync(recursive: true);
  }

  context.logger.info('Finding Flutter executable...');

  final flutterPath = await findFlutterPath();

  context.logger.info('Configuring Flutter platforms...');

  final platforms = [
    'enable-web',
    'enable-linux-desktop',
    'enable-macos-desktop',
    'enable-windows-desktop',
    'enable-android',
    'enable-ios',
    'enable-fuchsia',
    'enable-custom-devices',
    'enable-swift-package-manager',
  ];

  for (var platform in platforms) {
    final result = await Process.run(flutterPath, ['config', '--$platform'],
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
        },
        runInShell: true);

    if (result.exitCode != 0) {
      context.logger.err('Failed to configure $platform: ${result.stderr}');
    } else {
      context.logger.info('$platform configured successfully.');
    }
  }

  context.logger.info('Creating Flutter project with --overwrite flag...');

  final result = await Process.run(flutterPath,
      ['create', '--org', orgName, projectName, '--overwrite', '-e'],
      environment: {
        'PATH': Platform.environment['PATH'] ?? '',
      },
      runInShell: true);

  if (result.exitCode != 0) {
    context.logger.err('Failed to create project: ${result.stderr}');
    return;
  }

  context.logger.info('Project created successfully!');

  Directory.current = projectDirectory.path;

  // Create core package
  final corePath = '$projectName/core';
  Process.runSync(
      flutterPath,
      [
        'create',
        '--org',
        orgName,
        '-t',
        'package',
        'core',
      ],
      environment: {
        'PATH': Platform.environment['PATH'] ?? '',
      },
      runInShell: true);

  // Create features packages
  final features = ['updater', 'themer', 'l10nr'];
  for (var feature in features) {
    final featurePath = '$projectName/features/$feature';
    Process.runSync(
        flutterPath,
        [
          'create',
          '--org',
          orgName,
          '-t',
          'package',
          'features/$feature',
        ],
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
        },
        runInShell: true);
  }

  // Create shared packages
  final sharedPackages = ['preferences', 'i10n', 'packages', 'components'];
  for (var sharedPackage in sharedPackages) {
    final sharedPath = '$projectName/shared/$sharedPackage';
    Process.runSync(
        flutterPath,
        [
          'create',
          '--org',
          orgName,
          '-t',
          'package',
          'shared/$sharedPackage',
        ],
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
        },
        runInShell: true);
  }

  context.logger.info('Modular Flutter project generated successfully!');
}
