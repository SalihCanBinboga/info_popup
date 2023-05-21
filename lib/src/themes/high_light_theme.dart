import 'package:flutter/material.dart'
    show BorderRadius, Color, Colors, EdgeInsets;

/// The [HighLightTheme] class is used to customize the highlighter.
class HighLightTheme {
  /// Creates a [HighLightTheme].
  HighLightTheme({
    required this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.radius = BorderRadius.zero,
  }) : assert(
          backgroundColor != Colors.transparent,
          '\n\nThe backgroundColor can not be transparent. \n'
          'Description: The backgroundColor can not be transparent. '
          'Please use another color.  \n \n'
          'For example: Colors.black.withOpacity(.5) \n',
        );

  /// Default [HighLightTheme].
  factory HighLightTheme.defaultTheme() => HighLightTheme(
        backgroundColor: Colors.black.withOpacity(.5),
      );

  /// The [radius] of the highlighter.
  final BorderRadius radius;

  /// The [padding] of the highlighter.
  final EdgeInsets padding;

  /// The [backgroundColor] of background area color.
  final Color backgroundColor;
}
