import 'package:chat_app/utils/extractor.dart';
import 'package:chat_app/controllers/reminder.dart';
import 'package:flutter/material.dart';

class SavedMessageWidget extends StatelessWidget {
  int user;
  String message;
  SavedMessageWidget(
    this.user,
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        left: 8,
        right: 8,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.85,
        //padding: const EdgeInsets.all(10),
        alignment: user == 1 ? Alignment.topRight : Alignment.topLeft,
        child: Card(
            color: user == 1 ? Colors.lightBlue : Colors.grey,
            child: Padding(
                padding: const EdgeInsets.all(8.0), child: Text(message))),
      ),
    );
  }
}
