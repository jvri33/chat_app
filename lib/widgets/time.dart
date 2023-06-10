import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chat_app/controllers/saved_message.dart';

class TimeWidget extends StatefulWidget {
  String time;
  int id;
  String message;
  TimeWidget(
      {required this.time, required this.id, required this.message, super.key});

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Hora: ${widget.time}",
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
      IconButton(
          constraints: BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                    hour: int.parse(widget.time.split(":")[0]),
                    minute: int.parse(widget.time.split(":")[1])));

            if (pickedTime != null) {
              setState(() {
                List<String> mess = widget.message.split("/");

                int hora = pickedTime.hour;
                int minute = pickedTime.minute;

                String horas = hora.toString();
                String minutoss = minute.toString();

                if (hora < 10) {
                  horas = "0${hora.toString()}";
                }
                if (minute < 10) {
                  minutoss = "0${minute.toString()}";
                }
                mess[5] = "${horas}:${minutoss}";
                print(pickedTime.format(context));
                String messSt = mess.join("/");
                SavedMessage s = SavedMessage();
                s.updateMessageTime(messSt, widget.id);
              });
            }
          },
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ))
    ]);
  }
}
