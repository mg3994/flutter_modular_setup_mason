part of '../config.dart';

// class StagingConfig implements FlavorConfig {
//   const StagingConfig();

//   @override
//   String get appName => "[STG] Antinna";

//   @override
//   String get baseUrl => 'https://stg.example.com';

//   @override
//   final flavor = Flavor.staging;
// }
final class _StagingFlavorConfig extends FlavorConfig {
  const _StagingFlavorConfig()
      : super._internal(
            "[STG] Antinna", 'https://stag.example.com', Flavor.staging,'AlOp7lBkcFRdJnXFkGcBHwM9I9TJMMgr',true);
}