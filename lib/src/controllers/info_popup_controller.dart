import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

import '../painters/arrow_indicator_painter.dart';

part '../overlays/overlay_entry_layout.dart';

/// Popup manager for the InfoPopup widget.
/// [InfoPopupController] is used to show and dismiss the popup.
class InfoPopupController {
  /// Creates a [InfoPopupController] widget.
  InfoPopupController({
    required this.context,
    required RenderBox targetRenderBox,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    required this.layerLink,
    required this.dismissTriggerBehavior,
    this.infoPopupDismissed,
    this.contentTitle,
    this.customContent,
    this.onAreaPressed,
    this.onLayoutMounted,
    this.contentOffset = Offset.zero,
    this.indicatorOffset = Offset.zero,
    this.contentMaxWidth,
  }) : _targetRenderBox = targetRenderBox;

  /// The [layerLink] is the layer link of the popup.
  final LayerLink layerLink;

  /// The context of the widget.
  final BuildContext context;

  /// The [_targetRenderBox] is the render box of the info text.
  RenderBox _targetRenderBox;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [contentTitle] to show in the popup.
  final String? contentTitle;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? customContent;

  /// The [areaBackgroundColor] is the background color of the area that
  final Color areaBackgroundColor;

  /// [arrowTheme] is the arrow theme of the popup.
  final InfoPopupArrowTheme arrowTheme;

  /// [contentTheme] is the content theme of the popup.
  final InfoPopupContentTheme contentTheme;

  /// [onAreaPressed] Called when the area outside the popup is pressed.
  final OnAreaPressed? onAreaPressed;

  /// [onLayoutMounted] Called when the info layout is mounted.
  final Function(Size size)? onLayoutMounted;

  /// The [contentOffset] is the offset of the content.
  final Offset contentOffset;

  /// The [indicatorOffset] is the offset of the indicator.
  final Offset indicatorOffset;

  /// The [dismissTriggerBehavior] is the dismissing behavior of the popup.
  final PopupDismissTriggerBehavior dismissTriggerBehavior;

  /// The [_infoPopupOverlayEntry] is the overlay entry of the popup.
  OverlayEntry? _infoPopupOverlayEntry;

  /// The [infoPopupContainerSize] is the size of the popup.
  Size? infoPopupContainerSize;

  /// [contentMaxWidth] is the max width of the content that is being showed.
  /// If the [contentMaxWidth] is null, the max width will be eighty percent
  /// of the screen.
  final double? contentMaxWidth;

  /// The [show] method is used to show the popup.
  void show() {
    _infoPopupOverlayEntry = OverlayEntry(
      builder: (_) {
        return OverlayInfoPopup(
          targetRenderBox: _targetRenderBox,
          contentTitle: contentTitle,
          layerLink: layerLink,
          customContent: customContent,
          areaBackgroundColor: areaBackgroundColor,
          indicatorTheme: arrowTheme,
          contentTheme: contentTheme,
          contentOffset: contentOffset,
          indicatorOffset: indicatorOffset,
          dismissTriggerBehavior: dismissTriggerBehavior,
          contentMaxWidth: contentMaxWidth,
          onLayoutMounted: (Size size) {
            Future<void>.delayed(
              const Duration(milliseconds: 30),
              () {
                infoPopupContainerSize = size;
                _infoPopupOverlayEntry?.markNeedsBuild();

                if (onLayoutMounted != null) {
                  onLayoutMounted!.call(size);
                }
              },
            );
          },
          onAreaPressed: () {
            if (onAreaPressed != null) {
              onAreaPressed!.call(this);
              return;
            }

            dismissInfoPopup();
          },
        );
      },
    );

    Overlay.of(context)!.insert(_infoPopupOverlayEntry!);
  }

  /// The [isShowing] method is used to check if the popup is showing.
  bool get isShowing => _infoPopupOverlayEntry != null;

  /// [dismissInfoPopup] is used to dismiss the popup.
  void dismissInfoPopup() {
    if (_infoPopupOverlayEntry != null) {
      _infoPopupOverlayEntry!.remove();
      _infoPopupOverlayEntry = null;

      if (infoPopupDismissed != null) {
        infoPopupDismissed!.call();
      }
    }
  }

  /// [updateInfoPopupTargetRenderBox] is used to update the render box of the info text.
  void updateInfoPopupTargetRenderBox(RenderBox renderBox) {
    _targetRenderBox = renderBox;
    _infoPopupOverlayEntry?.markNeedsBuild();
  }
}
