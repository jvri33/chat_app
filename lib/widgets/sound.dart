import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/controllers/saved_message.dart';

class SoundWidget extends StatefulWidget {
  int id;
  String message;
  int sound;
  bool so = false;

  SoundWidget(
      {required this.sound,
      required this.message,
      required this.id,
      super.key}) {
    if (this.sound == 1) {
      so = true;
    } else {
      so = false;
    }
  }

  @override
  State<SoundWidget> createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Sonido: ",
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Checkbox(
          value: widget.so,
          onChanged: (newv) async {
            setState(() {
              widget.so = newv!;

              List<String> mess = widget.message.split("/");
              mess[2] = (widget.so ? 1 : 0).toString();
              String messSt = mess.join("/");
              SavedMessage s = SavedMessage();
              s.updateMessageSound(messSt, widget.id);
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
