import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catan_master/domain/feedback/feedback_message.dart';
import 'package:equatable/equatable.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

//TODO cubit
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackState.initial());

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    yield state.copyWith(event.feedback);
  }

  void feedback(FeedbackMessage feedbackMessage) {
    add(FeedbackEvent(feedbackMessage));
  }

  void snackbar(String message, {Severity severity = Severity.message}) {
    add(FeedbackEvent(FeedbackMessage.snackbar(message, severity: severity)));
  }

  void dialog(String message, {required String title, Severity severity = Severity.message}) {
    add(FeedbackEvent(FeedbackMessage.dialog(message, title: title, severity: severity)));
  }
}
