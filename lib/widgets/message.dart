import 'package:chat_app/widgets/extractor.dart';
import 'package:chat_app/widgets/reminder.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  String intentPrediction;
  bool user;
  List entities;
  String message;
  Message(this.intentPrediction, this.user, this.message,
      {this.entities = const []});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  void initState() {
    super.initState();
  }

  String checkIntent() {
    String ret = "";
    if (widget.intentPrediction == "REMINDER1") {
      ret = (Extractor(widget.entities).fecha()).toString();
      Reminder r;
    }
    return ret;
  }

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
        alignment: widget.user ? Alignment.topRight : Alignment.topLeft,
        child: Card(
            color: widget.user ? Colors.lightBlue : Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.user
                  ? Text(widget.message)
                  : Column(
                      children: [
                        Text("${widget.intentPrediction}"),
                        Text(checkIntent()) //Text("${widget.entities} "),
                      ],
                    ),
            )),
      ),
    );
  }
}
