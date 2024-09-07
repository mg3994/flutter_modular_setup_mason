part of '../config.dart';

// class ProductionConfig implements FlavorConfig {
//   const ProductionConfig();
//   @override
//   String get appName => "Antinna";

//   @override
//   String get baseUrl => 'https://example.com';

//   @override
//   final flavor = Flavor.production;
// }

final class _ProductionFlavorConfig extends FlavorConfig {
  const _ProductionFlavorConfig()
      : super._internal(
            'Antinna', 'https://jsonplaceholder.typicode.com/posts', Flavor.production,'AlOp7lBkcFRdJnXFkGcBHwM9I9TJMMgr',true);
}