import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:info_popup/info_popup.dart';

/// A widget that shows a popup with text.
class InfoPopupWidget extends StatefulWidget {
  /// Creates a [InfoPopupWidget] widget.
  const InfoPopupWidget({
    required this.child,
    this.onControllerCreated,
    this.infoPopupDismissed,
    this.contentTitle,
    this.customContent,
    this.areaBackgroundColor,
    this.arrowTheme,
    this.contentTheme,
    this.onAreaPressed,
    this.onLayoutMounted,
    this.dismissTriggerBehavior = PopupDismissTriggerBehavior.onTapArea,
    this.contentOffset,
    this.indicatorOffset,
    this.contentMaxWidth,
    this.enableHighlight = false,
    this.highLightTheme,
    this.enableLog = false,
    super.key,
  }) : assert(customContent == null || contentTitle == null,
            'You can not use both customContent and contentTitle at the same time.');

  /// The [child] of the [InfoPopupWidget].
  final Widget child;

  /// [onControllerCreated] is called when the [InfoPopupController] is created.
  final OnControllerCreated? onControllerCreated;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [contentTitle] to show in the popup.
  final String? contentTitle;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? Function()? customContent;

  /// The [areaBackgroundColor] is the background color of the area that
  final Color? areaBackgroundColor;

  /// [arrowTheme] is the arrow theme of the popup.
  final InfoPopupArrowTheme? arrowTheme;

  /// [contentTheme] is the content theme of the popup.
  final InfoPopupContentTheme? contentTheme;

  /// [onAreaPressed] Called when the area outside the popup is pressed.
  final OnAreaPressed? onAreaPressed;

  /// [onLayoutMounted] Called when the info layout is mounted.
  final Function(Size size)? onLayoutMounted;

  /// The [dismissTriggerBehavior] is the showing behavior of the popup.
  final PopupDismissTriggerBehavior dismissTriggerBehavior;

  /// The [contentOffset] is the offset of the content..
  final Offset? contentOffset;

  /// The [indicatorOffset] is the offset of the indicator.
  final Offset? indicatorOffset;

  /// [contentMaxWidth] is the max width of the content that is shown.
  /// If the [contentMaxWidth] is null, the max width will be eighty percent
  /// of the screen.
  final double? contentMaxWidth;

  /// The [enableHighlight] is the boolean value that indicates whether the
  /// highlight is enabled or not.
  final bool enableHighlight;

  /// The [enableLog] is the boolean value that indicates whether the
  /// log is enabled or not.
  ///
  /// If the [enableLog] is true, the log will be shown in the console.
  final bool enableLog;

  /// The [highLightTheme] is the theme of the highlight. Can customize the
  /// highlight border radius and the padding.
  final HighLightTheme? highLightTheme;

  @override
  State<InfoPopupWidget> createState() => _InfoPopupWidgetState();
}

class _InfoPopupWidgetState extends State<InfoPopupWidget> {
  final GlobalKey<State<StatefulWidget>> _infoPopupTargetKey = GlobalKey();
  InfoPopupController? _infoPopupController;
  bool _isControllerInitialized = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    if (_infoPopupController != null && _infoPopupController!.isShowing) {
      _infoPopupController!.dismissInfoPopup();
    }
    super.dispose();
  }

  bool get _isMouseRegionPermitted {
    final bool mouseIsConnected =
        RendererBinding.instance.mouseTracker.mouseIsConnected;

    if (!mouseIsConnected || !_isControllerInitialized) {
      return false;
    }

    return true;
  }

  @override
  void didUpdateWidget(InfoPopupWidget oldWidget) {
    if (widget.customContent != null && _infoPopupController != null) {
      _infoPopupController!.updateContent();
    } else if (oldWidget.contentTitle != widget.contentTitle ||
        oldWidget.areaBackgroundColor != widget.areaBackgroundColor ||
        oldWidget.arrowTheme != widget.arrowTheme ||
        oldWidget.contentTheme != widget.contentTheme ||
        oldWidget.contentOffset != widget.contentOffset ||
        oldWidget.indicatorOffset != widget.indicatorOffset ||
        oldWidget.contentMaxWidth != widget.contentMaxWidth ||
        oldWidget.enableHighlight != widget.enableHighlight ||
        oldWidget.highLightTheme != widget.highLightTheme ||
        oldWidget.dismissTriggerBehavior != widget.dismissTriggerBehavior) {
      if (_infoPopupController != null || _isControllerInitialized) {
        _infoPopupController!.dismissInfoPopup();
        _infoPopupController = null;
        _isControllerInitialized = false;
      }
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateRenderBox());
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        if (_isMouseRegionPermitted && !_infoPopupController!.isShowing) {
          _infoPopupController!.show();
        }
      },
      onExit: (PointerExitEvent event) {
        if (widget.dismissTriggerBehavior ==
            PopupDismissTriggerBehavior.manuel) {
          return;
        }

        if (_isMouseRegionPermitted && _infoPopupController!.isShowing) {
          _infoPopupController!.dismissInfoPopup();
        }
      },
      child: GestureDetector(
        // ignore: use_if_null_to_convert_nulls_to_bools
        onTap: _infoPopupController?.isShowing == true
            ? null
            : () {
                if (_infoPopupController != null &&
                    !_infoPopupController!.isShowing) {
                  _infoPopupController!.show();
                }
              },
        behavior: HitTestBehavior.translucent,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            key: _infoPopupTargetKey,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Future<void> _updateRenderBox() async {
    final BuildContext? context = _infoPopupTargetKey.currentContext;

    if (!mounted || context == null) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    _infoPopupController = _infoPopupController ??= InfoPopupController(
      context: context,
      targetRenderBox: renderBox,
      layerLink: _layerLink,
      contentTitle: widget.contentTitle,
      customContent: widget.customContent,
      areaBackgroundColor: widget.areaBackgroundColor ??
          PopupConstants.defaultAreaBackgroundColor,
      arrowTheme: widget.arrowTheme ?? const InfoPopupArrowTheme(),
      contentTheme: widget.contentTheme ?? const InfoPopupContentTheme(),
      onAreaPressed: widget.onAreaPressed,
      onLayoutMounted: (Size size) {
        setState(() {
          widget.onLayoutMounted?.call(size);
        });
      },
      dismissTriggerBehavior: widget.dismissTriggerBehavior,
      infoPopupDismissed: () {
        setState(() {
          widget.infoPopupDismissed?.call();
        });
      },
      contentOffset: widget.contentOffset ?? const Offset(0, 0),
      indicatorOffset: widget.indicatorOffset ?? const Offset(0, 0),
      contentMaxWidth: widget.contentMaxWidth,
      enableHighlight: widget.enableHighlight,
      highLightTheme: widget.highLightTheme ?? HighLightTheme.defaultTheme(),
    );

    if (!_isControllerInitialized && widget.onControllerCreated != null) {
      widget.onControllerCreated!.call(_infoPopupController!);
    }

    _infoPopupController!.updateInfoPopupTargetRenderBox(renderBox);

    _isControllerInitialized = true;
  }
}
