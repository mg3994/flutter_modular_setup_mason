# Flutter Modular Setup

Hello From {{org_name}}!

This template is designed to help you quickly set up a Flutter project following the Modular Clean Architecture principles. It leverages the power of Mason to scaffold a well-structured, maintainable, and scalable project.

## Overview

The **Flutter Modular Setup** template is created by a Mason Brick named **flutter_modular_setup**. It provides a solid foundation for building Flutter applications with a clean separation of concerns, following SOLID principles.

## Features

- **Modular Structure**: The template organizes your project into distinct modules, each responsible for a specific feature or functionality. This ensures that your codebase remains clean, maintainable, and scalable.
- **Clean Architecture**: Adheres to the principles of Clean Architecture, separating the app into layers (presentation, domain, and data) to ensure clear boundaries and maintainable code.
- **SOLID Principles**: The setup promotes the use of SOLID principles in your Flutter project, encouraging best practices in software design.

## Usage

To generate a new Flutter project using this template, run the following command:
##### 🎯 Activate from [https://pub.dev](https://pub.dev/packages/mason_cli)
```bash

dart pub global activate mason_cli
```

##### 🚀 Initialize mason
```bash
mason init 
```
# Now add into
> mason.yaml
```yaml
bricks:
  flutter_modular_setup:
    path: flutter_modular_setup # path to that brick or may be till take available as hosted on https://brickhub.dev/bricks/flutter_modular_setup
```
```bash
mason get
```

##### you can change output directory > `-o ./my_flutter_project ` to any directory > `-o ./your_dirctory_name `
```bash
mason make flutter_modular_setup -o ./my_flutter_project 
```

## Remember 
> package name or say bundle name depend on your input if valid then it will be like `org_name.project_name` <br> 
---
> project name will be your input for `project_name` if valid