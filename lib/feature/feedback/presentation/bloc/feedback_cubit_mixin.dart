import 'package:catan_master/core/core.dart';
import 'package:catan_master/feature/feedback/domain/feedback_message.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';

mixin FeedbackCubitMixin {
  FeedbackCubit get feedbackCubit;

  void feedback(FeedbackMessage? feedback) {
    if (feedback != null) {
      feedbackCubit.showFeedback(feedback);
    }
  }

  void failureFeedback(
    Failure failure, {
    String? message,
    FeedbackMethod method = FeedbackMethod.toast,
    bool? barrierDismissable,
    String? code,
  }) {
    feedback(FeedbackMessage(
      method: method,
      message: message ?? failure.message,
    ));
  }

  void toast(String message, {Severity severity = Severity.message}) {
    return feedback(FeedbackMessage.toast(message, severity: severity));
  }

  void snackbar(String message, {Severity severity = Severity.message, FeedbackAction? action}) {
    feedback(FeedbackMessage.snackbar(message, severity: severity, action: action));
  }

  void modal(
    String message, {
    Severity severity = Severity.message,
    String? title,
    List<FeedbackAction> actions = FeedbackMessage.defaultDialogActions,
  }) {
    feedback(FeedbackMessage.dialog(
      message,
      severity: severity,
      title: title,
      actions: actions,
    ));
  }
}
