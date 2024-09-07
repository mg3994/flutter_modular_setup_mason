import 'package:flutter/material.dart';

/// The signature of the custom [ALayoutBuilder] builder function.
typedef ALayoutWidgetBuilder = Widget Function(
  BuildContext context,
  Size constraints,
  bool isTablet,
  bool isLandscape,
);

///Much better then orientationBuilder
final class ALayoutBuilder extends StatelessWidget {
  const ALayoutBuilder({
    super.key,
    required this.builder,
  });

  final ALayoutWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //if required try wrapping it in Safearea (i already used it somewhere else so saving memory) as we are =>  Constraints Passed: The Size object passed to the builder now reflects the usable area within the safe area, not the entire screen
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isLandscape =
            constraints.biggest.width > constraints.biggest.height;

        // Determine device type based on the shortest side
        final bool isTablet = constraints.biggest.shortestSide >= 600;
        // // Calculate the device's diagonal screen size in inches
        // final mediaQuery = MediaQuery.of(context);
        // final double diagonalInches = (constraints.biggest.width / mediaQuery.devicePixelRatio).hypot(
        //   constraints.biggest.height / mediaQuery.devicePixelRatio,
        // );

        // // Determine if the device is a tablet based on diagonal size
        // final bool isTablet = diagonalInches >= 7.0;

        return builder(context, constraints.biggest, isTablet, isLandscape);
      },
    );
  }
}