import 'package:catan_master/feature/feedback/domain/feedback_message.dart';
import 'package:catan_master/feature/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:catan_master/feature/feedback/presentation/show_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserFeedback extends StatelessWidget {
  final Widget child;

  const UserFeedback({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listenWhen: (_s1, _s2) => ModalRoute.of(context)?.isCurrent ?? false,
      listener: (context, FeedbackState state) {
        FeedbackMessage feedback = state.last;
        feedback.show(context);
      },
      child: child,
    );
  }
}
