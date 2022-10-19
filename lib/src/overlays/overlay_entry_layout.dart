part of '../controllers/info_popup_controller.dart';

/// [InfoPopup] is a widget that shows a popup with a text and an arrow indicator.
class OverlayInfoPopup extends StatefulWidget {
  /// Creates a [InfoPopup] widget.
  const OverlayInfoPopup({
    required this.layerLink,
    required this.targetRenderBox,
    required this.customContent,
    required this.contentTitle,
    required this.areaBackgroundColor,
    required this.indicatorTheme,
    required this.contentTheme,
    required this.onAreaPressed,
    required this.onLayoutMounted,
    required this.indicatorOffset,
    required this.contentOffset,
    required this.dismissTriggerBehavior,
    super.key,
  });

  /// The [layerLink] is the layer link of the popup.
  final LayerLink layerLink;

  /// The [targetRenderBox] is the render box of the target widget.
  final RenderBox targetRenderBox;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? customContent;

  /// The [contentTitle] is the title of the popup.
  final String? contentTitle;

  /// The [areaBackgroundColor] is the background color of the area that
  final Color areaBackgroundColor;

  /// [indicatorTheme] is the indicator theme of the popup.
  final InfoPopupArrowTheme indicatorTheme;

  /// [contentTheme] is the content theme of the popup.
  final InfoPopupContentTheme contentTheme;

  /// [onAreaPressed] Called when the area outside the popup is pressed.
  final VoidCallback onAreaPressed;

  /// [onLayoutMounted] Called when the info layout is mounted.
  final Function(Size size) onLayoutMounted;

  /// [contentOffset] is the offset of the content.
  final Offset contentOffset;

  /// [indicatorOffset] is the offset of the indicator.
  final Offset indicatorOffset;

  /// [dismissTriggerBehavior] is the behavior of the popup when the popup is pressed.
  final PopupDismissTriggerBehavior dismissTriggerBehavior;

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

  Offset get _indicatorOffset {
    final double indicatorWidth = widget.indicatorTheme.arrowSize.width;
    switch (widget.indicatorTheme.arrowDirection) {
      case ArrowDirection.up:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              _targetWidgetRect.height,
            ) +
            widget.indicatorOffset;
      case ArrowDirection.down:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              -widget.indicatorTheme.arrowSize.height,
            ) +
            widget.indicatorOffset;
    }
  }

  Offset get _bodyOffset {
    final Size contentSize = _contentSize == null ? Size.zero : _contentSize!;

    Offset targetCenterOffset = Offset.zero;

    switch (widget.indicatorTheme.arrowDirection) {
      case ArrowDirection.up:
        targetCenterOffset = Offset(
          _targetWidgetRect.width / 2 - contentSize.width / 2,
          _targetWidgetRect.height + widget.indicatorTheme.arrowSize.height,
        );
        break;
      case ArrowDirection.down:
        targetCenterOffset = Offset(
          _targetWidgetRect.width / 2 - contentSize.width / 2,
          -(contentSize.height + widget.indicatorTheme.arrowSize.height),
        );
        break;
    }

    if (widget.layerLink.leader == null) {
      return targetCenterOffset;
    }

    Offset finalOffset = Offset.zero;

    final LayerLink link = widget.layerLink;
    final double targetWidth = _targetWidgetRect.width;
    final double targetDx = widget.targetRenderBox.localToGlobal(Offset.zero).dx;
    final double targetRightCorner = targetDx + link.leaderSize!.width;
    final double rightGap = context.screenWidth - targetRightCorner;
    final double leftGap = targetDx;

    finalOffset = const Offset(0, 0);

    if (rightGap < contentSize.width / 2 && leftGap > contentSize.width / 2) {
      finalOffset = Offset(
        -(contentSize.width - targetWidth) / 2 + rightGap,
        0,
      );
    } else if (leftGap < contentSize.width / 2) {
      finalOffset = Offset(
        (contentSize.width - targetWidth) / 2 - leftGap,
        0,
      );
    }

    return targetCenterOffset + finalOffset + widget.contentOffset;
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

  Rect get _targetWidgetRect {
    final Offset offset = widget.targetRenderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      widget.targetRenderBox.size.width,
      widget.targetRenderBox.size.height,
    );
  }

  double get _contentMaxHeight {
    const int padding = 16;
    final double screenHeight = context.screenHeight;
    final double bottomPadding = context.mediaQuery.padding.bottom;
    final double topPadding = context.mediaQuery.padding.top;
    final double targetWidgetTopPosition = _targetWidgetRect.top;

    switch (widget.indicatorTheme.arrowDirection) {
      case ArrowDirection.up:
        final double belowSpace = screenHeight -
            targetWidgetTopPosition -
            _targetWidgetRect.height -
            padding -
            bottomPadding;
        return belowSpace;
      case ArrowDirection.down:
        final double aboveSpace = targetWidgetTopPosition - topPadding;
        return aboveSpace;
    }
  }

  Offset get _areaOffset {
    switch (widget.dismissTriggerBehavior) {
      case PopupDismissTriggerBehavior.onTapContent:
        return _bodyOffset;
      case PopupDismissTriggerBehavior.onTapArea:
        return Offset(-_targetWidgetRect.left, -_targetWidgetRect.top);
    }
  }

  bool get dismissBehaviorIsOnTapContent =>
      widget.dismissTriggerBehavior == PopupDismissTriggerBehavior.onTapContent;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: CompositedTransformFollower(
        link: widget.layerLink,
        showWhenUnlinked: false,
        offset: _areaOffset,
        child: GestureDetector(
          onTap: widget.onAreaPressed,
          behavior: dismissBehaviorIsOnTapContent
              ? null
              : HitTestBehavior.translucent,
          child: Material(
            color: widget.areaBackgroundColor,
            child: SizedBox(
              height:
                  dismissBehaviorIsOnTapContent ? null : context.screenHeight,
              width: dismissBehaviorIsOnTapContent ? null : context.screenWidth,
              child: Column(
                mainAxisSize: dismissBehaviorIsOnTapContent
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: <Widget>[
                  CompositedTransformFollower(
                    link: widget.layerLink,
                    showWhenUnlinked: false,
                    offset: _indicatorOffset,
                    child: CustomPaint(
                      size: widget.indicatorTheme.arrowSize,
                      painter: widget.indicatorTheme.arrowPainter ??
                          ArrowIndicatorPainter(
                            arrowDirection:
                                widget.indicatorTheme.arrowDirection,
                            arrowColor: widget.indicatorTheme.color,
                          ),
                    ),
                  ),
                  CompositedTransformFollower(
                    link: widget.layerLink,
                    showWhenUnlinked: false,
                    offset: _bodyOffset,
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
                                    color: widget.contentTheme
                                        .infoContainerBackgroundColor,
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
                                    widget.contentTitle ?? '',
                                    style: widget.contentTheme.infoTextStyle,
                                    textAlign:
                                        widget.contentTheme.infoTextAlign,
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
          ),
        ),
      ),
    );
  }
}
