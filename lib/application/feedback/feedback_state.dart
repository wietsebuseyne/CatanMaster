part of 'feedback_bloc.dart';

class FeedbackState extends Equatable {

  final List<FeedbackMessage> feedbackList;

  FeedbackMessage get last => feedbackList.last;

  FeedbackState.initial() : feedbackList = [];

  FeedbackState(List<FeedbackMessage> feedbackList) : this.feedbackList = List.unmodifiable(feedbackList);

  @override
  List<Object> get props => [feedbackList];

  FeedbackState copyWith(FeedbackMessage feedback) => FeedbackState(List.of(feedbackList)..add(feedback));

}