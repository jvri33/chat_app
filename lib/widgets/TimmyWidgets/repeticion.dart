import 'package:flutter/material.dart';
import 'package:chat_app/controllers/saved_message.dart';

// ignore: must_be_immutable
class RepeatWidget extends StatelessWidget {
  int repeat;
  int id;
  String message;
  bool re = false;
  RepeatWidget(
      {required this.repeat,
      required this.message,
      required this.id,
      required this.onUpdateRepeat,
      super.key}) {
    if (repeat == 1) {
      re = true;
    } else {
      re = false;
    }
  }

  final Function(String) onUpdateRepeat;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text("Repetición: ",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
          value: re,
          onChanged: (newv) async {
            re = newv!;

            List<String> mess = message.split("/");
            mess[3] = (re ? 1 : 0).toString();
            String messSt = mess.join("/");
            SavedMessage s = SavedMessage();
            s.updateMessageRepeat(messSt, id);

            onUpdateRepeat(mess[3]);
          },
          side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 2, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      )
    ]);
  }
}
