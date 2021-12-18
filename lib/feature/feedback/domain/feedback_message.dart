import 'package:flutter/foundation.dart';

class FeedbackMessage {
  final FeedbackMethod method;
  final Severity severity;
  final String? title;
  final String message;
  final List<FeedbackAction> actions;

  bool get hasAction => actions.isNotEmpty;

  FeedbackAction? get action => actions.isNotEmpty ? actions.first : null;

  FeedbackMessage({
    required this.method,
    required this.message,
    this.severity = Severity.message,
    this.title,
    List<FeedbackAction> actions = const [],
  })  : assert(method == FeedbackMethod.dialog || title == null),
        assert(method != FeedbackMethod.snackbar || actions.length <= 1),
        assert(method != FeedbackMethod.toast || actions.isEmpty),
        assert(method != FeedbackMethod.dialog || actions.isNotEmpty),
        this.actions = List.unmodifiable(actions);

  FeedbackMessage.toast(this.message, {this.severity = Severity.message})
      : actions = const [],
        title = null,
        method = FeedbackMethod.toast;

  FeedbackMessage.snackbar(
    this.message, {
    FeedbackAction? action,
    this.severity = Severity.message,
  })  : actions = action == null ? const [] : List.unmodifiable([action]),
        title = null,
        method = FeedbackMethod.snackbar;

  FeedbackMessage.dialog(
    this.message, {
    required this.title,
    this.severity = Severity.message,
    this.actions = defaultDialogActions,
  }) : method = FeedbackMethod.dialog;

  static const defaultDialogActions = [FeedbackAction.dismiss(text: "OK")];
}

class FeedbackAction {
  final String text;
  final Future<void> Function(VoidCallback pop) action;

  FeedbackAction({required this.text, required this.action});

  const FeedbackAction.dismiss({required this.text, this.action = _pop});

  static Future<void> _pop(VoidCallback pop) async => pop.call();
}

enum Severity { message, success, warning, error }

enum FeedbackMethod { toast, snackbar, dialog }
