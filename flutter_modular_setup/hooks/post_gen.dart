import 'dart:io';
import 'package:mason/mason.dart';

// Finds the Flutter executable path
Future<String> findFlutterPath() async {
  final command = Platform.isWindows ? 'where flutter' : 'which flutter';
  final result = await Process.run(command, [], runInShell: true);

  if (result.exitCode == 0) {
    final paths = result.stdout.split('\n').map((e) => e.trim()).toList();
    // Return the first path, assuming it's the correct executable
    return paths.first;
  } else {
    throw Exception('Unable to find Flutter executable: ${result.stderr}');
  }
}

// Executes a command and logs the result
Future<void> runAndLog(
    String executable, List<String> arguments, HookContext context) async {
  final result = await Process.runSync(executable, arguments,
      environment: {'PATH': Platform.environment['PATH'] ?? ''},
      runInShell: true);
  if (result.exitCode != 0) {
    context.logger
        .err('Failed to execute ${arguments.join(' ')}: ${result.stderr}');
  } else {
    context.logger.info('${arguments.join(' ')} executed successfully.');
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
    'web',
    'linux-desktop',
    'macos-desktop',
    'windows-desktop',
    'android',
    'ios',
    'fuchsia',
    'custom-devices',
    'swift-package-manager'
  ];

  for (var platform in platforms) {
    await runAndLog(flutterPath, ['config', '--enable-$platform'], context);
  }

  context.logger.info('Creating Flutter project...');
  await runAndLog(
      flutterPath,
      [
        'create',
        '--org',
        orgName,
        projectName,
        '--description',
        'A modular Flutter application scaffold with core, feature, and shared packages for clean architecture.'
      ],
      context);

  Directory.current = projectDirectory.path;

  // Helper function to create packages
  Future<void> createPackage(String path, String description) async {
    await runAndLog(
        flutterPath,
        [
          'create',
          '--org',
          orgName,
          '-t',
          'package',
          path,
          '--description',
          description
        ],
        context);
  }

  // Create core and feature packages
  await createPackage('core',
      'Core functionalities and services for the modular Flutter application.');
  for (var feature in ['updater', 'themer', 'l10nr']) {
    await createPackage(
        'features/$feature', 'Feature package for managing $feature Feature');
  }
  for (var sharedPackage in ['preferences', 'l10n', 'packages', 'components']) {
    await createPackage(
        'shared/$sharedPackage', 'Shared Resources Package for $sharedPackage');
  }

  context.logger.info('Activating Melos CLI...');
  await runAndLog(flutterPath, ['pub', 'global', 'activate', 'melos'], context);

  // Run melos commands
  final melosCommands = [
    ['run', 'publish_to_none'],
    ['run', 'analyzer_macros'],
    ['run', 'add_dependencies_to_packages'],
    ['run', 'add_dependencies_to_features'],
    ['run', 'add_dev_dependencies_to_features'],
    ['run', 'add_dependencies_to_core'],
    ['run', 'add_dependencies_to_l10n'],
    ['run', 'add_dependencies_to_$projectName'],
    ['bootstrap'],
    ['run', 'add_flutter_intl'],
    ['run', 'generate:l10n'],
  ];

  for (var command in melosCommands) {
    await runAndLog('melos', command, context);
  }

  context.logger.info('Modular Flutter project generated successfully!');
}
