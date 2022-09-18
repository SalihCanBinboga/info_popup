import 'package:flutter/material.dart'
    show
        BorderRadius,
        Color,
        Colors,
        EdgeInsets,
        EdgeInsetsGeometry,
        TextAlign,
        TextStyle;
import 'package:info_popup/src/constants/popup_constants.dart';

/// [InfoPopupContentTheme] is used to customize the content of the popup.
class InfoPopupContentTheme {
  /// [InfoPopupContentTheme] creates a theme for the content of the popup.
  /// [infoTextStyle] is used to customize the text style of the content.
  /// [infoTextAlign] is used to customize the text align of the content.
  /// [infoContainerBackgroundColor] is used to customize the background color of the content.
  /// [contentPadding] is used to customize the padding of the content.
  /// [contentBorderRadius] is used to customize the border radius of the content.
  const InfoPopupContentTheme({
    this.infoTextStyle = PopupConstants.defaultInfoTextStyle,
    this.infoTextAlign = TextAlign.center,
    this.infoContainerBackgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.all(8.0),
    this.contentBorderRadius = PopupConstants.defaultContentBorderRadius,
  });

  /// The [infoTextStyle] of the info text.
  final TextStyle infoTextStyle;

  /// The [infoTextAlign] of the info text.
  final TextAlign infoTextAlign;

  /// The [infoContainerBackgroundColor] of the info container color.
  final Color infoContainerBackgroundColor;

  /// The [padding] of the info container.
  final EdgeInsetsGeometry contentPadding;

  /// The [borderRadius] of the info container.
  final BorderRadius contentBorderRadius;

  /// [copyWith] is used to copy the [InfoPopupContentTheme] with new values.
  InfoPopupContentTheme copyWith({
    TextStyle? infoTextStyle,
    TextAlign? infoTextAlign,
    Color? infoContainerBackgroundColor,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? contentBorderRadius,
  }) {
    return InfoPopupContentTheme(
      infoTextStyle: infoTextStyle ?? this.infoTextStyle,
      infoTextAlign: infoTextAlign ?? this.infoTextAlign,
      infoContainerBackgroundColor:
          infoContainerBackgroundColor ?? this.infoContainerBackgroundColor,
      contentPadding: contentPadding ?? this.contentPadding,
      contentBorderRadius: contentBorderRadius ?? this.contentBorderRadius,
    );
  }
}
