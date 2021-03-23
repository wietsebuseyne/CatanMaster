
class FeedbackMessage {

  final FeedbackType type;
  final Severity severity;
  final String? title;
  final String message;
  final List<FeedbackAction> actions;

  bool get hasAction => actions.isNotEmpty;

  FeedbackAction? get action => actions.isNotEmpty ? actions.first : null;

  FeedbackMessage.toast(this.message, {this.severity = Severity.message})
      : actions = const [],
        title = null,
        type = FeedbackType.toast;

  FeedbackMessage.snackbar(this.message, {FeedbackAction? action, this.severity = Severity.message})
      : actions = action == null ? const [] : List.unmodifiable([action]),
        title = null,
        type = FeedbackType.snackbar;

  FeedbackMessage.dialog(this.message, {required this.title, this.severity = Severity.message})
      : actions = const [],
        type = FeedbackType.dialog;

}

class FeedbackAction {

  final String text;
  final Function action;

  FeedbackAction({required this.text, required this.action});

}

enum Severity {
  message, success, warning, error
}

enum FeedbackType {
  toast, snackbar, dialog
}