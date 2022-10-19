import 'package:flutter/material.dart';
import 'package:info_popup/src/extensions/context_extensions.dart';
import 'package:info_popup/src/painters/arrow_indicator_painter.dart';
import 'package:info_popup/src/themes/info_popup_arrow_theme.dart';
import 'package:info_popup/src/themes/info_popup_content_theme.dart';

import '../enums/arrow_alignment.dart';
import '../enums/arrow_direction.dart';

/// [InfoPopup] is a widget that shows a popup with a text and an arrow indicator.
class OverlayInfoPopup extends StatefulWidget {
  /// Creates a [InfoPopup] widget.
  const OverlayInfoPopup({
    required this.infoPopupTargetOffset,
    required this.targetRenderBox,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    required this.onAreaPressed,
    required this.onLayoutMounted,
    this.customContent,
    this.infoText,
    super.key,
  });

  /// [infoPopupTargetOffset] is the offset of the info popup container.
  final Offset infoPopupTargetOffset;

  /// [targetRenderBox] is the rect of the info popup container.
  final Rect targetRenderBox;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? customContent;

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
  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _updateContentLayoutSize();
      },
    );
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
              left: _indicatorDx,
              top: _indicatorDy,
              child: CustomPaint(
                size: widget.arrowTheme.arrowSize,
                painter: widget.arrowTheme.arrowPainter ??
                    ArrowIndicatorPainter(
                      arrowDirection: widget.arrowTheme.arrowDirection,
                      arrowColor: widget.arrowTheme.color,
                    ),
              ),
            ),
            AnimatedPositioned(
              left: _contentHorizontalPosition,
              top: _contentDy,
              duration: const Duration(milliseconds: 50),
              curve: Curves.bounceInOut,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                child: Transform.scale(
                  scale: _isLayoutDone ? 1.0 : 0.0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.screenWidth * .8,
                      maxHeight: _contentMaxHeight,
                    ),
                    child: Container(
                      key: _bodyKey,
                      decoration: widget.customContent != null
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
                      padding: widget.customContent != null
                          ? null
                          : widget.contentTheme.contentPadding,
                      child: SingleChildScrollView(
                        child: widget.customContent ??
                            Text(
                              widget.infoText ?? '',
                              style: widget.contentTheme.infoTextStyle,
                              textAlign: widget.contentTheme.infoTextAlign,
                            ),
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

  void _updateContentLayoutSize() {
    Future<dynamic>.microtask(
      () {
        setState(
          () {
            final RenderBox? renderBox =
                _bodyKey.currentContext!.findRenderObject() as RenderBox?;

            if (renderBox != null) {
              final Size size = renderBox.size;
              _contentSize = size;
              widget.onLayoutMounted(size);
            }
          },
        );
      },
    );
  }

  Size? _contentSize;

  Size get contentSize {
    if (_contentSize == null) {
      return widget.targetRenderBox.size;
    } else {
      return _contentSize!;
    }
  }

  bool get _isLayoutDone => _contentSize != null;

  double get _indicatorDy {
    final double arrowGap = widget.arrowTheme.arrowGap;
    switch (widget.arrowTheme.arrowDirection) {
      case ArrowDirection.up:
        return widget.infoPopupTargetOffset.dy +
            widget.arrowTheme.arrowSize.height / 2 +
            arrowGap;
      case ArrowDirection.down:
        return widget.infoPopupTargetOffset.dy -
            widget.targetRenderBox.height -
            arrowGap;
    }
  }

  double get _indicatorDx {
    final double arrowWidth = widget.arrowTheme.arrowSize.width;
    final double holderStart = widget.targetRenderBox.left;
    final double holderEnd = widget.targetRenderBox.right;

    switch (widget.arrowTheme.arrowAlignment) {
      case ArrowAlignment.left:
        final double xRadius =
            widget.contentTheme.contentBorderRadius.topLeft.x;
        return holderStart - arrowWidth / 2 + xRadius;
      case ArrowAlignment.right:
        return holderEnd - arrowWidth / 2;
      case ArrowAlignment.center:
        return _dXTargetCenter - arrowWidth / 2;
    }
  }

  double get _contentDy {
    switch (widget.arrowTheme.arrowDirection) {
      case ArrowDirection.up:
        return _indicatorDy + widget.arrowTheme.arrowSize.height;
      case ArrowDirection.down:
        return _indicatorDy - contentSize.height;
    }
  }

  double get _contentHorizontalPosition {
    const double horizontalGap = 16;
    final double targetLeft = widget.targetRenderBox.left;
    final double contentWidth = contentSize.width;
    final double screenWith = context.screenWidth;
    final double dXTargetCenter = _dXTargetCenter - contentSize.width / 2;

    if (dXTargetCenter < 0) {
      return targetLeft < horizontalGap ? targetLeft : horizontalGap;
    } else if (dXTargetCenter + contentWidth > screenWith) {
      return ((targetLeft + widget.targetRenderBox.width) >
              (screenWith - horizontalGap))
          ? targetLeft + widget.targetRenderBox.width - contentWidth
          : screenWith - contentWidth - horizontalGap;
    } else {
      return dXTargetCenter;
    }
  }

  double get _dXTargetCenter {
    return widget.targetRenderBox.left + (widget.targetRenderBox.width / 2.0);
  }

  double get _contentMaxHeight {
    const int padding = 16;
    final double screenHeight = context.screenHeight;
    final double bottomPadding = context.mediaQuery.padding.bottom;
    final double topPadding = context.mediaQuery.padding.top;
    final double targetWidgetTopPosition = widget.targetRenderBox.top;
    final double arrowGap = widget.arrowTheme.arrowGap;

    switch (widget.arrowTheme.arrowDirection) {
      case ArrowDirection.up:
        final double belowSpace = screenHeight -
            targetWidgetTopPosition -
            widget.targetRenderBox.height -
            arrowGap -
            padding -
            bottomPadding;
        return belowSpace;
      case ArrowDirection.down:
        final double aboveSpace = targetWidgetTopPosition - topPadding;
        return aboveSpace;
    }
  }
}
