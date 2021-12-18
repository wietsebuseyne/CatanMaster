import 'package:bloc/bloc.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit_mixin.dart';

class CatanBloc<Event, State> extends Bloc<Event, State> with FeedbackCubitMixin {
  @override
  final FeedbackCubit feedbackCubit;

  CatanBloc(State initialState, {required FeedbackCubit f})
      : this.feedbackCubit = f,
        super(initialState);
}
