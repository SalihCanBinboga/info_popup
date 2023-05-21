import 'package:flutter/material.dart'
    show BorderRadius, Color, Colors, EdgeInsets;

/// The [HighLightTheme] class is used to customize the highlighter.
class HighLightTheme {
  /// Creates a [HighLightTheme].
  HighLightTheme({
    required this.radius,
    required this.padding,
    required this.backgroundColor,
  }) : assert(
          backgroundColor != Colors.transparent,
          'The backgroundColor can not be transparent.',
        );

  /// Default [HighLightTheme].
  factory HighLightTheme.defaultTheme() => HighLightTheme(
        radius: BorderRadius.zero,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.black.withOpacity(.5),
      );

  /// The [radius] of the highlighter.
  final BorderRadius radius;

  /// The [padding] of the highlighter.
  final EdgeInsets padding;

  /// The [backgroundColor] of background area color.
  final Color backgroundColor;
}
