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
    required bool enableHighlight,
    required HighLightTheme highlightTheme,
    required VoidCallback hideOverlay,
    required bool enabledAutomaticConstraint,
    Widget? Function()? customContent,
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
        _contentMaxWidth = contentMaxWidth,
        _enableHighlight = enableHighlight,
        _highLightTheme = highlightTheme,
        _enabledAutomaticConstraint = enabledAutomaticConstraint,
        _hideOverlay = hideOverlay;

  final LayerLink _layerLink;
  final RenderBox _targetRenderBox;
  final Widget? Function()? _customContent;
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
  final bool _enableHighlight;
  final HighLightTheme _highLightTheme;
  final VoidCallback _hideOverlay;
  final bool _enabledAutomaticConstraint;

  @override
  State<OverlayInfoPopup> createState() => _OverlayInfoPopupState();
}

class _OverlayInfoPopupState extends State<OverlayInfoPopup> {
  final GlobalKey _bodyKey = GlobalKey();

  @override
  void initState() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _updateContentLayoutSize();
      },
    );
    super.initState();
  }

  bool _isPointListenerDisposed = false;

  void _handlePointerEvent(PointerEvent event) {
    if (!mounted) {
      return;
    }

    final bool mouseIsConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;

    if (mouseIsConnected) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(
        _handlePointerEvent,
      );
      _isPointListenerDisposed = true;
      return;
    }

    final RenderBox? renderBox =
        _bodyKey.currentContext!.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final Offset clickPosition = event.position;
    final Offset contentPosition = renderBox.localToGlobal(Offset.zero);

    switch (widget._dismissTriggerBehavior) {
      case PopupDismissTriggerBehavior.onTapContent:
        if (clickPosition.dx >= contentPosition.dx &&
            clickPosition.dx <= contentPosition.dx + contentSize.width &&
            clickPosition.dy >= contentPosition.dy &&
            clickPosition.dy <= contentPosition.dy + contentSize.height) {
          widget._hideOverlay();
        }
        break;
      case PopupDismissTriggerBehavior.onTapArea:
        if (!(clickPosition.dx >= contentPosition.dx &&
            clickPosition.dx <= contentPosition.dx + contentSize.width &&
            clickPosition.dy >= contentPosition.dy &&
            clickPosition.dy <= contentPosition.dy + contentSize.height)) {
          widget._onAreaPressed();
        }
        break;
      case PopupDismissTriggerBehavior.anyWhere:
        widget._hideOverlay();
        break;
      case PopupDismissTriggerBehavior.manuel:
        // do nothing
        break;
    }
  }

  @override
  void dispose() {
    if (!_isPointListenerDisposed) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(
        _handlePointerEvent,
      );
    }

    super.dispose();
  }

  ArrowDirection? _overridenArrowDirection;

  ArrowDirection get arrowDirection {
    if (_overridenArrowDirection != null) {
      return _overridenArrowDirection!;
    }

    return widget._indicatorTheme.arrowDirection;
  }

  Offset get _indicatorOffset {
    final double indicatorWidth = widget._indicatorTheme.arrowSize.width;
    switch (arrowDirection) {
      case ArrowDirection.up:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              _targetWidgetRect.height,
            ) +
            widget._indicatorOffset +
            _highlightOffset;
      case ArrowDirection.down:
        return Offset(
              _targetWidgetRect.width / 2 - indicatorWidth / 2,
              -widget._indicatorTheme.arrowSize.height,
            ) +
            widget._indicatorOffset +
            _highlightOffset;
    }
  }

  Offset get _highlightOffset {
    double highlightVerticalGap = 0;

    if (widget._enableHighlight) {
      highlightVerticalGap = widget._highLightTheme.padding.bottom;
    }

    switch (arrowDirection) {
      case ArrowDirection.up:
        return Offset(0, highlightVerticalGap);
      case ArrowDirection.down:
        return Offset(0, -highlightVerticalGap);
    }
  }

  Offset get _bodyOffset {
    Offset targetCenterOffset = Offset.zero;

    final double contentWidth = contentSize.width;
    final double contentHeight = contentSize.height;
    final double targetWidth = _targetWidgetRect.width;
    final double targetHeight = _targetWidgetRect.height;
    final double contentDxCenter = targetWidth / 2 - contentWidth / 2;

    switch (arrowDirection) {
      case ArrowDirection.up:
        targetCenterOffset = Offset(
          contentDxCenter,
          targetHeight + widget._indicatorTheme.arrowSize.height,
        );
        break;
      case ArrowDirection.down:
        targetCenterOffset = Offset(
          contentDxCenter,
          -(contentHeight + widget._indicatorTheme.arrowSize.height),
        );
        break;
    }

    targetCenterOffset += _highlightOffset;

    final double contentLeft = contentDxCenter + _targetOffset.dx;
    final double contentRight = contentLeft + contentWidth;
    final double screenWidth = context.screenWidth;

    if (contentLeft < 0) {
      targetCenterOffset += Offset(-contentLeft, 0);
    } else if (contentRight > screenWidth) {
      targetCenterOffset += Offset(screenWidth - contentRight, 0);
    }

    return targetCenterOffset + widget._contentOffset;
  }

  Size? _contentSize;

  Size get contentSize {
    if (!_isLayoutMounted) {
      return widget._targetRenderBox.size;
    } else {
      return _contentSize!;
    }
  }

  @override
  void didUpdateWidget(covariant OverlayInfoPopup oldWidget) {
    _updateContentLayoutSize();
    _contentMaxHeight;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _updateContentLayoutSize();
    _contentMaxHeight;
    super.didChangeDependencies();
  }

  bool _isLayoutMounted = false;

  void _updateContentLayoutSize() {
    Future<dynamic>.microtask(
      () {
        Future<void>.delayed(
          const Duration(milliseconds: 50),
          () {
            if (!mounted) {
              return;
            }

            if (_bodyKey.currentContext == null) {
              return;
            }

            final RenderBox? renderBox =
                _bodyKey.currentContext!.findRenderObject() as RenderBox?;

            if (renderBox == null) {
              return;
            }

            final Size size = renderBox.size;

            if (size != _contentSize) {
              setState(
                () {
                  _contentSize = size;

                  widget._onLayoutMounted(size);
                  _isLayoutMounted = true;
                },
              );
            }
          },
        );
      },
    );
  }

  Rect get _targetWidgetRect {
    if (!widget._targetRenderBox.attached) {
      return Rect.zero;
    }

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
    final double contentHeight = _contentSize?.height ?? 0;
    final bool isArrowDirectionOverriden = _overridenArrowDirection != null;

    switch (arrowDirection) {
      case ArrowDirection.up:
        final double belowSpace = screenHeight -
            targetWidgetTopPosition -
            _targetWidgetRect.height -
            padding -
            bottomPadding;

        if (!widget._indicatorTheme.enabledAutoArrowDirection) {
          return belowSpace;
        }

        if ((belowSpace - contentHeight) > 0 || isArrowDirectionOverriden) {
          return belowSpace;
        } else {
          _setIndicatorDirection(ArrowDirection.down);
          return 0;
        }
      case ArrowDirection.down:
        final double aboveSpace = targetWidgetTopPosition - topPadding;

        if (!widget._indicatorTheme.enabledAutoArrowDirection) {
          return aboveSpace;
        }

        if ((aboveSpace - contentHeight) > 0 || isArrowDirectionOverriden) {
          return aboveSpace;
        } else {
          _setIndicatorDirection(ArrowDirection.up);
          return 0;
        }
    }
  }

  Offset get _areaOffset {
    if (widget._enableHighlight) {
      return Offset(-_targetWidgetRect.left, -_targetWidgetRect.top);
    }

    switch (widget._dismissTriggerBehavior) {
      case PopupDismissTriggerBehavior.onTapContent:
        return _bodyOffset;
      case PopupDismissTriggerBehavior.onTapArea:
      case PopupDismissTriggerBehavior.anyWhere:
      case PopupDismissTriggerBehavior.manuel:
        return Offset(-_targetWidgetRect.left, -_targetWidgetRect.top);
    }
  }

  Offset get _targetOffset {
    return widget._targetRenderBox.localToGlobal(Offset.zero);
  }

  bool get _dismissBehaviorIsOnTapContent =>
      widget._dismissTriggerBehavior ==
      PopupDismissTriggerBehavior.onTapContent;

  @override
  Widget build(BuildContext context) {
    _contentMaxHeight;
    return ClipPath(
      clipper: widget._enableHighlight
          ? _HighLighter(
              area: Rect.fromLTWH(
                _targetWidgetRect.left,
                _targetWidgetRect.top,
                _targetWidgetRect.width,
                _targetWidgetRect.height,
              ),
              padding: widget._highLightTheme.padding,
              radius: widget._highLightTheme.radius,
            )
          : null,
      child: Align(
        child: CompositedTransformFollower(
          link: widget._layerLink,
          showWhenUnlinked: false,
          offset: _areaOffset,
          child: Material(
            color: widget._enableHighlight
                ? widget._highLightTheme.backgroundColor
                : widget._areaBackgroundColor,
            type: (!widget._enableHighlight &&
                    widget._areaBackgroundColor == Colors.transparent)
                ? MaterialType.transparency
                : MaterialType.canvas,
            child: SizedBox(
              height:
                  _dismissBehaviorIsOnTapContent ? null : context.screenHeight,
              width:
                  _dismissBehaviorIsOnTapContent ? null : context.screenWidth,
              child: Column(
                children: <Widget>[
                  CompositedTransformFollower(
                    link: widget._layerLink,
                    showWhenUnlinked: false,
                    offset: _indicatorOffset,
                    child: AnimatedScale(
                      scale: _isLayoutMounted ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 50),
                      alignment: Alignment.topCenter,
                      child: CustomPaint(
                        size: widget._indicatorTheme.arrowSize,
                        painter: widget._indicatorTheme.arrowPainter ??
                            ArrowIndicatorPainter(
                              arrowDirection: arrowDirection,
                              arrowColor: widget._indicatorTheme.color,
                            ),
                      ),
                    ),
                  ),
                  CompositedTransformFollower(
                    link: widget._layerLink,
                    showWhenUnlinked: false,
                    offset: _bodyOffset,
                    child: AnimatedScale(
                      scale: _isLayoutMounted ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 50),
                      alignment: Alignment.topCenter,
                      child: Builder(builder: (BuildContext context) {
                        final Container content = Container(
                          key: _bodyKey,
                          decoration: widget._customContent != null
                              ? null
                              : BoxDecoration(
                                  color: widget._contentTheme
                                      .infoContainerBackgroundColor,
                                  borderRadius:
                                      widget._contentTheme.contentBorderRadius,
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
                            child: widget._customContent == null
                                ? Text(
                                    widget._contentTitle ?? '',
                                    style: widget._contentTheme.infoTextStyle,
                                    textAlign:
                                        widget._contentTheme.infoTextAlign,
                                  )
                                : widget._customContent!(),
                          ),
                        );

                        if (!widget._enabledAutomaticConstraint) {
                          return content;
                        }

                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: _contentMaxWidth,
                            maxHeight: _contentMaxHeight,
                          ),
                          child: content,
                        );
                      }),
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

  void _setIndicatorDirection(ArrowDirection newDirection) {
    if (!widget._indicatorTheme.enabledAutoArrowDirection) {
      return;
    }

    setState(() {
      _overridenArrowDirection = newDirection;
    });
  }
}
