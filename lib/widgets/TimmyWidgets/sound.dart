import 'package:flutter/material.dart';
import 'package:chat_app/controllers/saved_message.dart';

// ignore: must_be_immutable
class SoundWidget extends StatelessWidget {
  int id;
  String message;
  int sound;
  bool so = false;

  SoundWidget(
      {required this.sound,
      required this.message,
      required this.id,
      required this.onUpdateSound,
      super.key}) {
    if (sound == 1) {
      so = true;
    } else {
      so = false;
    }
  }

  final Function(String) onUpdateSound;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text("Sonido: ",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
          value: so,
          onChanged: (newv) async {
            if (message != "") {
              so = newv!;

              List<String> mess = message.split("/");
              if (mess[0] != "EDITING") {
                mess[2] = (so ? 1 : 0).toString();
              } else {
                mess[4] = (so ? 1 : 0).toString();
              }
              String messSt = mess.join("/");
              SavedMessage s = SavedMessage();
              s.updateMessageSound(messSt, id);

              if (mess[0] != "EDITING") {
                onUpdateSound(mess[2]);
              } else {
                onUpdateSound(mess[4]);
              }
            }
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
