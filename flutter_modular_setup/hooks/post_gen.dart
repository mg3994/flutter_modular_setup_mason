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

  context.logger.info('Creating Flutter project without --overwrite flag...');

  final result = await Process.run(
      flutterPath,
      [
        'create',
        '--org',
        orgName,
        projectName,
        // '--overwrite',
        '-e',
        '--description',
        'A modular Flutter application scaffold with core, feature, and shared packages for clean architecture.'
      ],
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
        // '--overwrite',
        '--description',
        'Core functionalities and services for the modular Flutter application.'
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
          // '--overwrite',
          '--description',
          'Feature package for managing $feature Feature'
        ],
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
        },
        runInShell: true);
  }

  // Create shared packages
  final sharedPackages = ['preferences', 'l10n', 'packages', 'components'];
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
          // '--overwrite',
          '--description',
          'Shared Resources Package for $sharedPackage '
        ],
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
        },
        runInShell: true);
  }

  context.logger.info('Activating Melos CLI...');

  final melosActivateResult =
      await Process.run(flutterPath, ['pub', 'global', 'activate', 'melos'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosActivateResult.exitCode != 0) {
    context.logger
        .err('Melos CLI activation failed: ${melosActivateResult.stderr}');
    return;
  }

  context.logger.info('Melos CLI activated successfully!');

  ////
  context.logger.info('Melos Publish to none!');

  
  final melosPublishToNoneResult =
      await Process.run('melos', ['run', 'publish_to_none'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosPublishToNoneResult.exitCode != 0) {
    context.logger.err(
        'Melos Adding publish_to: none in pubspec files failed: ${melosPublishToNoneResult.stderr}');
  } else {
    context.logger
        .info('Melos added publish_to: none in pubspec files successfully.');
  }

  ///
  ///
  ////
  context.logger.info('Melos Analysis add Macro Experimental');

  
  final melosAnalysisMacroResult =
      await Process.run('melos', ['run', 'analyzer_macros'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosAnalysisMacroResult.exitCode != 0) {
    context.logger.err(
        'Melos Analysis add Macro Experimental in analysis files failed: ${melosAnalysisMacroResult.stderr}');
  } else {
    context.logger.info(
        'Melos Analysis add Macro Experimental in analysis files successfully.');
  }

  ///
  ///
  context.logger.info('Melos Features Add Dependency');

 
  final melosFeatureDependencyResult =
      await Process.run('melos', ['run', 'add_dependencies_to_features'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosFeatureDependencyResult.exitCode != 0) {
    context.logger.err(
        'Melos Features Add Dependency failed: ${melosFeatureDependencyResult.stderr}');
  } else {
    context.logger.info('Melos Features Added Dependency successfully.');
  }

  ///
  ///
  
   ///
  context.logger.info('Melos Features Add Dev Dependency');

 
  final melosFeatureDevDependencyResult =
      await Process.run('melos', ['run', 'add_dev_dependencies_to_features'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosFeatureDevDependencyResult.exitCode != 0) {
    context.logger.err(
        'Melos Features Add Dev Dependency failed: ${melosFeatureDevDependencyResult.stderr}');
  } else {
    context.logger.info('Melos Features Added Dev Dependency successfully.');
  }

  ///
  
  ///
   ///
  context.logger.info('Melos Core Add Dependency');

 
  final melosCoreDependencyResult =
      await Process.run('melos', ['run', 'add_dependencies_to_core'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosCoreDependencyResult.exitCode != 0) {
    context.logger.err(
        'Melos Core Add Dependency failed: ${melosCoreDependencyResult.stderr}');
  } else {
    context.logger.info('Melos Core Added Dependency successfully.');
  }

  ///
  ///
  ///
  ///


   ///
  context.logger.info('Melos Shared L10n Add Dependency');

 
  final melosSL10nDependencyResult =
      await Process.run('melos', ['run', 'add_dependencies_to_core'],
          environment: {
            'PATH': Platform.environment['PATH'] ?? '',
          },
          runInShell: true);

  if (melosSL10nDependencyResult.exitCode != 0) {
    context.logger.err(
        'Melos Shared L10n Add Dependency failed: ${melosSL10nDependencyResult.stderr}');
  } else {
    context.logger.info('Melos Shared L10n Added Dependency successfully.');
  }

  ///

  // Run melos bootstrap to install dependencies
  final melosResult = await Process.run('melos', ['bootstrap'],
      environment: {
        'PATH': Platform.environment['PATH'] ?? '',
      },
      runInShell: true);

  if (melosResult.exitCode != 0) {
    context.logger.err('Melos bootstrap failed: ${melosResult.stderr}');
  } else {
    context.logger.info('Melos bootstrap completed successfully.');
  }

  context.logger.info('Modular Flutter project generated successfully!'); //
}



//  flutter pub add -h
// Add dependencies to `pubspec.yaml`.

// Invoking `dart pub add foo bar` will add `foo` and `bar` to `pubspec.yaml`
// with a default constraint derived from latest compatible version.

// Add to dev_dependencies by prefixing with "dev:".

// Make dependency overrides by prefixing with "override:".

// Add packages with specific constraints or other sources by giving a descriptor
// after a colon.

// For example:
//   * Add a hosted dependency at newest compatible stable version:
//     `flutter pub add foo`
//   * Add a hosted dev dependency at newest compatible stable version:
//     `flutter pub add dev:foo`
//   * Add a hosted dependency with the given constraint
//     `flutter pub add foo:^1.2.3`
//   * Add multiple dependencies:
//     `flutter pub add foo dev:bar`
//   * Add a path dependency:
//     `flutter pub add 'foo:{"path":"../foo"}'`
//   * Add a hosted dependency:
//     `flutter pub add 'foo:{"hosted":"my-pub.dev"}'`
//   * Add an sdk dependency:
//     `flutter pub add 'foo:{"sdk":"flutter"}'`
//   * Add a git dependency:
//     `flutter pub add 'foo:{"git":"https://github.com/foo/foo"}'`
//   * Add a dependency override:
//     `flutter pub add 'override:foo:1.0.0'`
//   * Add a git dependency with a path and ref specified:
//     `flutter pub add \
//       'foo:{"git":{"url":"../foo.git","ref":"<branch>","path":"<subdir>"}}'`

// Usage: dart pub add [options] [<section>:]<package>[:descriptor] [<section>:]<package2>[:descriptor] ...]
// -h, --help               Print this usage information.
//     --[no-]offline       Use cached packages instead of accessing the network.
// -n, --dry-run            Report what dependencies would change but don't change any.
//     --[no-]precompile    Build executables in immediate dependencies.
// -C, --directory=<dir>    Run this in the directory <dir>.

// Run "dart help" to see global options.
// See https://dart.dev/tools/pub/cmd/pub-add for detailed documentation.
// PS C:\Users\DEEPAK SHARMA\OneDrive\Desktop\modular_flutter_clean_arch\flutter