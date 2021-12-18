import 'package:bloc/bloc.dart';
import 'package:catan_master/feature/feedback/domain/feedback_message.dart';
import 'package:equatable/equatable.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackState.initial());

  void feedback(FeedbackMessage feedbackMessage) {
    emit(state.copyWith(feedbackMessage));
  }

  void toast(String message, {Severity severity = Severity.message}) {
    emit(state.copyWith(FeedbackMessage.toast(message, severity: severity)));
  }

  void snackbar(String message, {Severity severity = Severity.message}) {
    emit(state.copyWith(FeedbackMessage.snackbar(message, severity: severity)));
  }

  void dialog(String message, {required String title, Severity severity = Severity.message}) {
    emit(state.copyWith(FeedbackMessage.dialog(message, title: title, severity: severity)));
  }
}
