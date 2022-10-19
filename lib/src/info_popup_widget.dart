import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:info_popup/info_popup.dart';

import 'enums/popup_trigger_behavior.dart';

/// A widget that shows a popup with text.
class InfoPopupWidget extends StatefulWidget {
  /// Creates a [InfoPopupWidget] widget.
  const InfoPopupWidget({
    required this.child,
    this.onControllerCreated,
    this.infoPopupDismissed,
    @Deprecated('Use [contentTitle] instead') this.infoText,
    this.contentTitle,
    @Deprecated('Use [customContent] instead') this.infoWidget,
    this.customContent,
    this.areaBackgroundColor,
    this.arrowTheme,
    this.contentTheme,
    this.onAreaPressed,
    this.onLayoutMounted,
    this.triggerBehavior = PopupTriggerBehavior.onTap,
    super.key,
  })  : assert((infoText == null && contentTitle == null) || infoWidget == null,
            "You can't use [infoText] & [contentTitle] and [infoWidget] at the same time."),
        assert(contentTitle == null || infoText == null,
            "You can't use [contentTitle] and [infoText] at the same time.");

  /// The [child] of the [InfoPopupWidget].
  final Widget child;

  /// [onControllerCreated] is called when the [InfoPopupController] is created.
  final OnControllerCreated? onControllerCreated;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [infoText] to show in the popup.
  @Deprecated('Use [contentTitle] instead')
  final String? infoText;

  /// The [contentTitle] to show in the popup.
  final String? contentTitle;

  /// The [infoWidget] is the widget that will be custom shown in the popup.
  @Deprecated('Use [customContent] instead')
  final Widget? infoWidget;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? customContent;

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

  /// The [triggerBehavior] is the showing behavior of the popup.
  final PopupTriggerBehavior triggerBehavior;

  @override
  State<InfoPopupWidget> createState() => _InfoPopupWidgetState();
}

class _InfoPopupWidgetState extends State<InfoPopupWidget> {
  final GlobalKey<State<StatefulWidget>> _infoPopupTargetKey = GlobalKey();
  InfoPopupController? _infoPopupController;
  bool _isControllerInitialized = false;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateRenderBox());
    return GestureDetector(
      onTap: () {
        if (widget.triggerBehavior == PopupTriggerBehavior.onTap) {
          if (_infoPopupController != null) {
            _infoPopupController!.show();
          }
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        key: _infoPopupTargetKey,
        child: widget.child,
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
      infoText: widget.contentTitle ?? widget.infoText,
      customContent: widget.customContent ?? widget.infoWidget,
      areaBackgroundColor: widget.areaBackgroundColor ??
          PopupConstants.defaultAreaBackgroundColor,
      arrowTheme: widget.arrowTheme ?? const InfoPopupArrowTheme(),
      contentTheme: widget.contentTheme ?? const InfoPopupContentTheme(),
      infoPopupDismissed: widget.infoPopupDismissed,
      onAreaPressed: widget.onAreaPressed,
      onLayoutMounted: widget.onLayoutMounted,
    );

    if (!_isControllerInitialized && widget.onControllerCreated != null) {
      widget.onControllerCreated!.call(_infoPopupController!);
    }

    _infoPopupController!.updateInfoPopupTargetRenderBox(renderBox);

    _isControllerInitialized = true;
  }
}
