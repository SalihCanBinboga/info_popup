import 'package:flutter/material.dart';
import 'package:info_popup/src/extensions/context_extensions.dart';
import 'package:info_popup/src/painters/arrow_indicator_painter.dart';
import 'package:info_popup/src/themes/info_popup_arrow_theme.dart';
import 'package:info_popup/src/themes/info_popup_content_theme.dart';

import '../enums/arrow_direction.dart';

/// [InfoPopup] is a widget that shows a popup with a text and an arrow indicator.
class OverlayInfoPopup extends StatefulWidget {
  /// Creates a [InfoPopup] widget.
  const OverlayInfoPopup({
    required this.infoPopupTargetOffset,
    required this.infoPopupTargetRenderBox,
    this.infoWidget,
    this.infoText,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    required this.onAreaPressed,
    required this.onLayoutMounted,
    super.key,
  });

  /// [infoPopupTargetOffset] is the offset of the info popup container.
  final Offset infoPopupTargetOffset;

  /// [infoPopupTargetRenderBox] is the rect of the info popup container.
  final Rect infoPopupTargetRenderBox;

  /// The [infoWidget] is the widget that will be custom shown in the popup.
  final Widget? infoWidget;

  /// The [infoText] to show in the popup.
  final String? infoText;

  /// The [areaBackgroundColor] is the background color of the area that
  final Color areaBackgroundColor;

  /// [arrowTheme] is the arrow theme of the popup.
  final InfoPopupArrowTheme arrowTheme;

  /// [contentTheme] is the content theme of the popup.
  final InfoPopupContentTheme contentTheme;

  /// [onAreaPressed] Called when the area outside the popup is pressed.
  final VoidCallback onAreaPressed;

  /// [onLayoutMounted] Called when the info layout is mounted.
  final Function(Size size) onLayoutMounted;

  @override
  State<OverlayInfoPopup> createState() => _OverlayInfoPopupState();
}

class _OverlayInfoPopupState extends State<OverlayInfoPopup> {
  /// The key of the body.
  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    /// Adds a post frame callback to the widget binding.
    WidgetsBinding.instance.addPostFrameCallback(_getLayoutSize);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onAreaPressed,
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: widget.areaBackgroundColor,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: _getDxHolderCenter - widget.arrowTheme.arrowSize.width / 2,
              top: _getIndicatorTopPosition,
              child: CustomPaint(
                size: widget.arrowTheme.arrowSize,
                painter: ArrowIndicatorPainter(
                  arrowDirection: widget.arrowTheme.arrowDirection,
                  arrowColor: widget.arrowTheme.color,
                ),
              ),
            ),
            // popup content
            Positioned(
              left: _getDxHolderCenter - infoPopupBodySize.width / 2,
              top: _getInfoTextContainerTopPosition,
              child: Transform.scale(
                scale: _isLayoutDone ? 1.0 : 0.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.screenWidth * .8,
                    maxHeight: _getContainerMaxHeight,
                  ),
                  child: Container(
                    key: _bodyKey,
                    decoration: widget.infoWidget != null
                        ? null
                        : BoxDecoration(
                            color: widget
                                .contentTheme.infoContainerBackgroundColor,
                            borderRadius:
                                widget.contentTheme.contentBorderRadius,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0xFF808080),
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                    padding: widget.infoWidget != null
                        ? null
                        : widget.contentTheme.contentPadding,
                    child: widget.infoWidget ??
                        SingleChildScrollView(
                          child: Text(
                            widget.infoText ?? '',
                            style: widget.contentTheme.infoTextStyle,
                            textAlign: widget.contentTheme.infoTextAlign,
                          ),
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Gets the size of the layout.
  void _getLayoutSize(Duration _) {
    Future<dynamic>.microtask(
      () {
        setState(
          () {
            final RenderBox? renderBox =
                _bodyKey.currentContext!.findRenderObject() as RenderBox?;

            if (renderBox != null) {
              final Size size = renderBox.size;
              _infoPopupBodySize = size;
              widget.onLayoutMounted(size);
            }
          },
        );
      },
    );
  }

  /// The size of the body.
  Size? _infoPopupBodySize;

  /// The size of the info popup.
  Size get infoPopupBodySize {
    if (_infoPopupBodySize == null) {
      return widget.infoPopupTargetRenderBox.size;
    } else {
      return _infoPopupBodySize!;
    }
  }

  /// Returns true if the layout is mounted.
  bool get _isLayoutDone => _infoPopupBodySize != null;

  /// Gets the indicator top position.
  double get _getIndicatorTopPosition {
    switch (widget.arrowTheme.arrowDirection) {
      case ArrowDirection.up:
        return widget.infoPopupTargetOffset.dy +
            widget.arrowTheme.arrowSize.height / 2;
      case ArrowDirection.down:
        return widget.infoPopupTargetOffset.dy -
            widget.infoPopupTargetRenderBox.height;
    }
  }

  /// Gets the indicator top position.
  double get _getInfoTextContainerTopPosition {
    switch (widget.arrowTheme.arrowDirection) {
      case ArrowDirection.up:
        return _getIndicatorTopPosition + widget.arrowTheme.arrowSize.height;
      case ArrowDirection.down:
        if (widget.infoWidget != null) {
          return _getIndicatorTopPosition - infoPopupBodySize.height;
        } else {
          return widget.infoPopupTargetOffset.dy -
              widget.infoPopupTargetRenderBox.height -
              infoPopupBodySize.height;
        }
    }
  }

  /// Gets the indicator left center position.
  double get _getDxHolderCenter {
    return widget.infoPopupTargetRenderBox.left +
        (widget.infoPopupTargetRenderBox.width / 2.0);
  }

  /// Gets the [widget.infoWidget] max height.
  double get _getContainerMaxHeight {
    return context.screenHeight -
        widget.infoPopupTargetRenderBox.top -
        context.mediaQuery.padding.bottom -
        16;
  }
}
