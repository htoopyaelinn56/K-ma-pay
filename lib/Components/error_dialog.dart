import 'package:flutter/material.dart';
import 'package:money_transfer/constants.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMsg;
  final String optionalTitle;
  final Function(BuildContext context) action;

  ErrorDialog(
    this.errorMsg,
    this.action, {
    this.optionalTitle = 'Error',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mainColor,
      title: Text(
        optionalTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      content: Text(errorMsg),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Okay',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            action(context);
          },
        ),
      ],
    );
  }
}
