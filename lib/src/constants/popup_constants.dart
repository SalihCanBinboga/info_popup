import 'package:flutter/material.dart';

/// [PopupConstants] is some constants used in the popup.
mixin PopupConstants {
  /// [defaultArrowSize] is used to create a default arrow size.
  static const Size defaultArrowSize = Size(15, 10);

  /// [defaultInfoTextStyle] is used to create a default info text style.
  static const TextStyle defaultInfoTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  /// [defaultContentBorderRadius] is used to create a default content border radius.
  static const BorderRadius defaultContentBorderRadius =
      BorderRadius.all(Radius.circular(8));

  /// [defaultAreaBackgroundColor] is used to create a default area background color.
  static const Color defaultAreaBackgroundColor = Colors.transparent;
}
