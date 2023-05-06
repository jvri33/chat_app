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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
      //padding: const EdgeInsets.all(10),
      alignment: user == 1 ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 75.0, // Ancho mínimo de 200.0
          maxWidth: 300.0,
        ),
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight:
                      user == 0 ? Radius.circular(16) : Radius.circular(0),
                  topRight: Radius.circular(16),
                  bottomLeft:
                      user == 1 ? Radius.circular(16) : Radius.circular(0)),
            ),
            color: user == 1
                ? Color.fromARGB(255, 187, 247, 223)
                : Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: Text(message,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: user == 1
                          ? Theme.of(context).primaryColor
                          : Colors.white)),
            )),
      ),
    );
  }
}
