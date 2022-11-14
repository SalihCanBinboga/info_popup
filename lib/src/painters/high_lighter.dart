
// ignore_for_file: use_late_for_private_fields_and_variables

part of '../controllers/info_popup_controller.dart';

class _HighLighter extends CustomClipper<Path> {
  _HighLighter({
    this.area = Rect.zero,
    this.radius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
  });

  final Rect area;
  final BorderRadius radius;
  final EdgeInsets padding;

  @override
  Path getClip(Size size) {
    final Rect rect = Rect.fromLTRB(
      area.left - padding.left,
      area.top - padding.top,
      area.right + padding.right,
      area.bottom + padding.bottom,
    );

    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: radius.topLeft,
          topRight: radius.topRight,
          bottomLeft: radius.bottomLeft,
          bottomRight: radius.bottomRight,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper is _HighLighter &&
          (radius != oldClipper.radius || area != oldClipper.area);
}
