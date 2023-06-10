import 'package:flutter/material.dart';
import 'package:chat_app/controllers/saved_message.dart';

class RepeatWidget extends StatefulWidget {
  int repeat;
  int id;
  String message;
  bool re = false;
  RepeatWidget(
      {required this.repeat,
      required this.message,
      required this.id,
      super.key}) {
    if (this.repeat == 1) {
      re = true;
    } else {
      re = false;
    }
  }

  @override
  State<RepeatWidget> createState() => _RepeatWidgetState();
}

class _RepeatWidgetState extends State<RepeatWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Repetición: ",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
          value: widget.re,
          onChanged: (newv) async {
            setState(() {
              widget.re = newv!;

              List<String> mess = widget.message.split("/");
              mess[3] = (widget.re ? 1 : 0).toString();
              String messSt = mess.join("/");
              SavedMessage s = SavedMessage();
              s.updateMessageRepeat(messSt, widget.id);
            });
          },
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(width: 2, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      )
    ]);
  }
}
