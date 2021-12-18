import 'package:catan_master/feature/feedback/domain/feedback_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ShowFeedback on FeedbackMessage {
  void show(BuildContext context) {
    switch (method) {
      case FeedbackMethod.toast:
        Fluttertoast.showToast(msg: message);
        break;
      case FeedbackMethod.snackbar:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          action: hasAction
              ? SnackBarAction(
                  textColor: severity == Severity.error ? Colors.red : null,
                  label: action!.text,
                  onPressed: () => action!.action(() => Navigator.of(context).pop),
                )
              : null,
        ));
        break;
      case FeedbackMethod.dialog:
        showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(title!),
                  content: Text(message),
                  actions: [
                    if (!hasAction)
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      ),
                    ...actions.map((a) => TextButton(
                          onPressed: () => action!.action(() => Navigator.of(context).pop),
                          child: Text(a.text),
                        ))
                  ],
                ));
        break;
    }
  }
}
