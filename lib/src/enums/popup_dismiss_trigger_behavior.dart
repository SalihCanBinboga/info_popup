/// [PopupDismissTriggerBehavior] is used to specify the trigger behavior of the info popup.
enum PopupDismissTriggerBehavior {
  /// [onTapContent] is used to dismiss the popup when the content is tapped.
  onTapContent,

  /// [onTapArea] is used to dismiss the popup when the area outside the popup is tapped.
  onTapArea,

  /// [anyWhere] is used to dismiss the popup when anywhere is tapped.
  anyWhere,

  /// [manuel] is used to dismiss the popup manually.
  manuel,
}
