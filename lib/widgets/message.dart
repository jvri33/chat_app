import 'package:chat_app/utils/extractor.dart';
import 'package:chat_app/controllers/reminder.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Message extends StatefulWidget {
  String intentPrediction;
  bool user;
  List entities;
  String message;
  // ignore: use_key_in_widget_constructors
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

  Future<String> checkIntent() async {
    String ret = "";
    //print("check");
    if (widget.intentPrediction == "REMINDER1") {
      //  ret = Extractor(widget.entities).fecha()
      List<String> str =
          (Extractor(widget.entities).fecha()).toString().split(" ");
      ret = "${str[0]} ";
      ret += (Extractor(widget.entities).hora().toString());
      Reminder reminder = Reminder();
      //reminder.createItem(ret);
      reminder.delete();
      //print(path);

      //print("ahora ")
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    //print("etst");
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
                        Text(widget.intentPrediction),
                        FutureBuilder(
                            future: checkIntent(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }),
                        //Text(checkIntent()) //Text("${widget.entities} "),
                      ],
                    ),
            )),
      ),
    );
  }
}
