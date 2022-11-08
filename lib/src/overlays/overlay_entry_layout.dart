part of '../controllers/info_popup_controller.dart';

/// [InfoPopup] is a widget that shows a popup with a text and an arrow indicator.
class OverlayInfoPopup extends StatefulWidget {
  /// Creates a [InfoPopup] widget.
  const OverlayInfoPopup({
    required LayerLink layerLink,
    required RenderBox targetRenderBox,
    required Color areaBackgroundColor,
    required InfoPopupArrowTheme indicatorTheme,
    required InfoPopupContentTheme contentTheme,
    required VoidCallback onAreaPressed,
    required Function(Size size) onLayoutMounted,
    required Offset contentOffset,
    required Offset indicatorOffset,
    required PopupDismissTriggerBehavior dismissTriggerBehavior,
    Widget? customContent,
    String? contentTitle,
    double? contentMaxWidth,
    super.key,
  })  : _layerLink = layerLink,
        _targetRenderBox = targetRenderBox,
        _areaBackgroundColor = areaBackgroundColor,
        _indicatorTheme = indicatorTheme,
        _contentTheme = contentTheme,
        _onAreaPressed = onAreaPressed,
        _onLayoutMounted = onLayoutMounted,
        _contentOffset = contentOffset,
        _indicatorOffset = indicatorOffset,
        _dismissTriggerBehavior = dismissTriggerBehavior,
        _customContent = customContent,
        _contentTitle = contentTitle,
        _contentMaxWidth = contentMaxWidth;

  final LayerLink _layerLink;
  final RenderBox _targetRenderBox;
  final Widget? _customContent;
  final String? _contentTitle;
  final Color _areaBackgroundColor;
  final InfoPopupArrowTheme _indicatorTheme;
  final InfoPopupContentTheme _contentTheme;
  final VoidCallback _onAreaPressed;
  final Function(Size size) _onLayoutMounted;
  final Offset _contentOffset;
  final Offset _indicatorOffset;
  final PopupDismissTriggerBehavior _dismissTriggerBehavior;
  final double? _contentMaxWidth;

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
    final double indicatorWidth = widget._indicatorTheme.arrowSize.width;
    switch (widget._indicatorTheme.arrowDirection) {
      case ArrowDirection.up:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              _targetWidgetRect.height,
            ) +
            widget._indicatorOffset;
      case ArrowDirection.down:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              -widget._indicatorTheme.arrowSize.height,
            ) +
            widget._indicatorOffset;
    }
  }

  Offset get _bodyOffset {
    final Size contentSize = _contentSize == null ? Size.zero : _contentSize!;

    Offset targetCenterOffset = Offset.zero;

    switch (widget._indicatorTheme.arrowDirection) {
      case ArrowDirection.up:
        targetCenterOffset = Offset(
          _targetWidgetRect.width / 2 - contentSize.width / 2,
          _targetWidgetRect.height + widget._indicatorTheme.arrowSize.height,
        );
        break;
      case ArrowDirection.down:
        targetCenterOffset = Offset(
          _targetWidgetRect.width / 2 - contentSize.width / 2,
          -(contentSize.height + widget._indicatorTheme.arrowSize.height),
        );
        break;
    }

    if (widget._layerLink.leader == null) {
      return targetCenterOffset;
    }

    Offset finalOffset = Offset.zero;

    final LayerLink link = widget._layerLink;
    final double targetWidth = _targetWidgetRect.width;
    final double targetDx =
        widget._targetRenderBox.localToGlobal(Offset.zero).dx;
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

    return targetCenterOffset + finalOffset + widget._contentOffset;
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
              widget._onLayoutMounted(size);
            }
          },
        );
      },
    );
  }

  Size? _contentSize;

  Size get contentSize {
    if (_contentSize == null) {
      return widget._targetRenderBox.size;
    } else {
      return _contentSize!;
    }
  }

  bool get _isLayoutDone => _contentSize != null;

  Rect get _targetWidgetRect {
    final Offset offset = widget._targetRenderBox.localToGlobal(Offset.zero);

    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      widget._targetRenderBox.size.width,
      widget._targetRenderBox.size.height,
    );
  }

  double get _contentMaxWidth {
    if (widget._contentMaxWidth == null) {
      return context.screenWidth * .8;
    } else {
      return widget._contentMaxWidth!;
    }
  }

  double get _contentMaxHeight {
    const int padding = 16;
    final double screenHeight = context.screenHeight;
    final double bottomPadding = context.mediaQuery.padding.bottom;
    final double topPadding = context.mediaQuery.padding.top;
    final double targetWidgetTopPosition = _targetWidgetRect.top;

    switch (widget._indicatorTheme.arrowDirection) {
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
    switch (widget._dismissTriggerBehavior) {
      case PopupDismissTriggerBehavior.onTapContent:
        return _bodyOffset;
      case PopupDismissTriggerBehavior.onTapArea:
        return Offset(-_targetWidgetRect.left, -_targetWidgetRect.top);
    }
  }

  bool get dismissBehaviorIsOnTapContent =>
      widget._dismissTriggerBehavior ==
      PopupDismissTriggerBehavior.onTapContent;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: CompositedTransformFollower(
        link: widget._layerLink,
        showWhenUnlinked: false,
        offset: _areaOffset,
        child: GestureDetector(
          onTap: widget._onAreaPressed,
          behavior: dismissBehaviorIsOnTapContent
              ? null
              : HitTestBehavior.translucent,
          child: Material(
            color: widget._areaBackgroundColor,
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
                    link: widget._layerLink,
                    showWhenUnlinked: false,
                    offset: _indicatorOffset,
                    child: CustomPaint(
                      size: widget._indicatorTheme.arrowSize,
                      painter: widget._indicatorTheme.arrowPainter ??
                          ArrowIndicatorPainter(
                            arrowDirection:
                                widget._indicatorTheme.arrowDirection,
                            arrowColor: widget._indicatorTheme.color,
                          ),
                    ),
                  ),
                  CompositedTransformFollower(
                    link: widget._layerLink,
                    showWhenUnlinked: false,
                    offset: _bodyOffset,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 100),
                      child: Transform.scale(
                        scale: _isLayoutDone ? 1.0 : 0.0,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: _contentMaxWidth,
                            maxHeight: _contentMaxHeight,
                          ),
                          child: Container(
                            key: _bodyKey,
                            decoration: widget._customContent != null
                                ? null
                                : BoxDecoration(
                                    color: widget._contentTheme
                                        .infoContainerBackgroundColor,
                                    borderRadius: widget
                                        ._contentTheme.contentBorderRadius,
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color(0xFF808080),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                            padding: widget._customContent != null
                                ? null
                                : widget._contentTheme.contentPadding,
                            child: SingleChildScrollView(
                              child: widget._customContent ??
                                  Text(
                                    widget._contentTitle ?? '',
                                    style: widget._contentTheme.infoTextStyle,
                                    textAlign:
                                        widget._contentTheme.infoTextAlign,
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
