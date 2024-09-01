import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  // Read vars.
  final orgName = context.vars['org_name'];
  final projectName = context.vars['project_name'];

  // Validate and rectify orgName
  if (orgName == null || orgName.isEmpty) {
    context.logger.err('org_name is required.');
    context.vars['org_name'] = 'com.example'; // Provide a default
    context.logger.info('Set default org_name to: ${context.vars['org_name']}');
  } else {
    // Replace spaces with underscores
    final formattedOrgName = orgName.replaceAll(' ', '_');

    // Validate orgName format
    final validOrgNamePattern = RegExp(r'^[a-zA-Z0-9_]+(\.[a-zA-Z0-9_]+)*$');
    if (!validOrgNamePattern.hasMatch(formattedOrgName)) {
      context.logger.err(
          'Invalid org_name format. It should be in the form "a.b.c" with only alphanumeric characters and underscores.');
      context.vars['org_name'] = 'com.example'; // Provide a default
      context.logger.info('Rectified org_name to: ${context.vars['org_name']}');
    } else {
      context.vars['org_name'] = formattedOrgName;
      context.logger.info('org_name is valid: ${context.vars['org_name']}');
    }
  }

  // Validate and rectify projectName
  final validProjectNamePattern = RegExp(r'^[a-zA-Z0-9_]+$');
  if (projectName == null || !validProjectNamePattern.hasMatch(projectName)) {
    context.logger.err(
        'Invalid project_name format. It should only contain letters, numbers, and underscores.');
    context.vars['project_name'] = 'my_flutter_project'; // Provide a default
    context.logger
        .info('Rectified project_name to: ${context.vars['project_name']}');
  } else {
    context.logger.info('project_name is valid.');
  }

  // Additional logic for other setup or preprocessing can be added here
}
