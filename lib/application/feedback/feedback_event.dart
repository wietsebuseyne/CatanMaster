part of 'feedback_bloc.dart';

class FeedbackEvent extends Equatable {
  final FeedbackMessage feedback;

  const FeedbackEvent(this.feedback);

  @override
  List<Object> get props => [feedback];
}
