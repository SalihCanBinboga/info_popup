import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';

/// Popup manager for the InfoPopup widget.
/// [InfoPopupController] is used to show and dismiss the popup.
class InfoPopupController {
  /// Creates a [InfoPopupController] widget.
  InfoPopupController({
    required this.context,
    required RenderBox targetRenderBox,
    this.infoPopupDismissed,
    this.infoText,
    this.customContent,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    this.onAreaPressed,
    this.onLayoutMounted,
  }) : _targetRenderBox = targetRenderBox;

  /// The context of the widget.
  final BuildContext context;

  /// The [targetRenderBox] is the render box of the info text.
  RenderBox _targetRenderBox;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [infoText] to show in the popup.
  final String? infoText;

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

  /// The [_infoPopupOverlayEntry] is the overlay entry of the popup.
  OverlayEntry? _infoPopupOverlayEntry;

  /// The [infoPopupContainerSize] is the size of the popup.
  Size? infoPopupContainerSize;

  /// The [show] method is used to show the popup.
  void show() {
    _infoPopupOverlayEntry = OverlayEntry(
      builder: (_) {
        return OverlayInfoPopup(
          infoPopupTargetOffset: holderOffset,
          targetRenderBox: targetGlobalRect,
          infoText: infoText,
          customContent: customContent,
          areaBackgroundColor: areaBackgroundColor,
          arrowTheme: arrowTheme,
          contentTheme: contentTheme,
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

  /// [holderOffset] is the offset of the holder.
  Offset get holderOffset {
    final double dx = targetGlobalRect.left + targetGlobalRect.width / 2.0;
    final double dy = targetGlobalRect.top + targetGlobalRect.height / 2.0;

    return Offset(dx, dy);
  }

  /// [targetGlobalRect] returns the global rect of the info text.
  Rect get targetGlobalRect {
    final Offset offset = _targetRenderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      _targetRenderBox.size.width,
      _targetRenderBox.size.height,
    );
  }

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
