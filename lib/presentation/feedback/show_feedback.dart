import 'package:catan_master/domain/feedback/feedback_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ShowFeedback on FeedbackMessage {
  void show(BuildContext context) {
    switch (type) {
      case FeedbackType.toast:
        Fluttertoast.showToast(msg: message);
        break;
      case FeedbackType.snackbar:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          action: hasAction
              ? SnackBarAction(
                  textColor: severity == Severity.error ? Colors.red : null,
                  label: action!.text,
                  onPressed: action!.action)
              : null,
        ));
        break;
      case FeedbackType.dialog:
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(title!),
                  content: Text(message),
                  actions: [
                    if (!hasAction)
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK")),
                    ...actions.map((a) =>
                        TextButton(onPressed: a.action, child: Text(a.text)))
                  ],
                ));
        break;
    }
  }
}
