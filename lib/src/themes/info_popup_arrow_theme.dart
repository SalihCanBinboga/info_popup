import 'package:flutter/material.dart' show Color, Colors, Size;
import 'package:info_popup/src/constants/popup_constants.dart';
import 'package:info_popup/src/enums/arrow_direction.dart';

/// [InfoPopupArrowTheme] is used to customize the arrow of the popup.
class InfoPopupArrowTheme {
  /// [InfoPopupArrowTheme] is creates a [InfoPopupArrowTheme] constructor.
  /// [arrowDirection] is used to customize the direction of the arrow.
  /// [arrowSize] is used to customize the size of the arrow.
  const InfoPopupArrowTheme({
    this.arrowSize = PopupConstants.defaultArrowSize,
    this.arrowDirection = ArrowDirection.up,
    this.color = Colors.black,
  });

  /// The size [arrowSize] of the arrow indicator.
  final Size arrowSize;

  /// The [arrowDirection] of the arrow indicator.
  final ArrowDirection arrowDirection;

  /// The [color] of the arrow indicator.
  final Color color;

  /// [copyWith] is used to copy the [InfoPopupArrowTheme] with new values.
  InfoPopupArrowTheme copyWith({
    Size? arrowSize,
    ArrowDirection? arrowDirection,
    Color? color,
  }) {
    return InfoPopupArrowTheme(
      arrowSize: arrowSize ?? this.arrowSize,
      arrowDirection: arrowDirection ?? this.arrowDirection,
      color: color ?? this.color,
    );
  }
}
