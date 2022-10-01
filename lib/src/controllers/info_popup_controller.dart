import 'package:flutter/material.dart';
import 'package:info_popup/src/overlays/overlay_entry_layout.dart';
import 'package:info_popup/src/themes/info_popup_arrow_theme.dart';
import 'package:info_popup/src/themes/info_popup_content_theme.dart';
import 'package:info_popup/src/typedefs/on_area_pressed.dart';

/// Popup manager for the InfoPopup widget.
/// [InfoPopupController] is used to show and dismiss the popup.
class InfoPopupController {
  /// Creates a [InfoPopupController] widget.
  InfoPopupController({
    required this.context,
    required this.infoPopupTargetRenderBox,
    this.infoPopupDismissed,
    this.infoText,
    this.infoWidget,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    this.onAreaPressed,
    this.onLayoutMounted,
  });

  /// The context of the widget.
  final BuildContext context;

  /// The [infoPopupTargetRenderBox] is the render box of the info text.
  final RenderBox infoPopupTargetRenderBox;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [infoText] to show in the popup.
  final String? infoText;

  /// The [infoWidget] is the widget that will be custom shown in the popup.
  final Widget? infoWidget;

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
          infoPopupTargetRenderBox: holderGlobalRect,
          infoText: infoText,
          infoWidget: infoWidget,
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
    final double dx = holderGlobalRect.left + holderGlobalRect.width / 2.0;
    final double dy = holderGlobalRect.top + holderGlobalRect.height / 2.0;

    return Offset(dx, dy);
  }

  /// [holderGlobalRect] returns the global rect of the info text.
  Rect get holderGlobalRect {
    final Offset offset = infoPopupTargetRenderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      infoPopupTargetRenderBox.size.width,
      infoPopupTargetRenderBox.size.height,
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
}
