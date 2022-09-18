import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:info_popup/info_popup.dart';

/// A widget that shows a popup with text.
class InfoPopupWidget extends StatefulWidget {
  /// Creates a [InfoPopupWidget] widget.
  const InfoPopupWidget({
    required this.child,
    required this.onControllerCreated,
    this.infoPopupDismissed,
    this.infoText,
    this.infoWidget,
    this.areaBackgroundColor,
    this.arrowTheme,
    this.contentTheme,
    this.onAreaPressed,
    this.onLayoutMounted,
    super.key,
  })  : assert(infoWidget == null || infoText == null),
        assert(infoWidget != null || infoText != null);

  /// The [child] of the [InfoPopupWidget].
  final Widget child;

  /// [onControllerCreated] is called when the [InfoPopupController] is created.
  final OnControllerCreated onControllerCreated;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [infoText] to show in the popup.
  final String? infoText;

  /// The [infoWidget] is the widget that will be custom shown in the popup.
  final Widget? infoWidget;

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

  @override
  State<InfoPopupWidget> createState() => _InfoPopupWidgetState();
}

class _InfoPopupWidgetState extends State<InfoPopupWidget> {
  final GlobalKey<State<StatefulWidget>> infoPopupHolderKey = GlobalKey();
  InfoPopupController? _infoPopupController;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(_getRenderBox);
    return Container(
      key: infoPopupHolderKey,
      child: widget.child,
    );
  }

  Future<void> _getRenderBox(Duration _) async {
    final BuildContext? context = infoPopupHolderKey.currentContext;
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));

    if (!mounted || context == null || _infoPopupController != null) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    _infoPopupController = InfoPopupController(
      context: context,
      infoPopupTargetRenderBox: renderBox,
      infoText: widget.infoText,
      infoWidget: widget.infoWidget,
      areaBackgroundColor: widget.areaBackgroundColor ??
          PopupConstants.defaultAreaBackgroundColor,
      arrowTheme: widget.arrowTheme ?? const InfoPopupArrowTheme(),
      contentTheme: widget.contentTheme ?? const InfoPopupContentTheme(),
      infoPopupDismissed: widget.infoPopupDismissed,
      onAreaPressed: widget.onAreaPressed,
      onLayoutMounted: widget.onLayoutMounted,
    );

    widget.onControllerCreated(_infoPopupController!);
  }
}
