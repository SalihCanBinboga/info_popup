import 'package:flutter/material.dart';

/// [BuildContextExtensions] is a class that contains extensions for [BuildContext]
extension BuildContextExtensions on BuildContext {
  /// Returns the [MediaQueryData] from the closest instance that encloses the given context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Return the [screenWidth] of the screen
  double get screenWidth => mediaQuery.size.width;

  /// Return the [screenHeight] of the screen
  double get screenHeight => mediaQuery.size.height;
}
