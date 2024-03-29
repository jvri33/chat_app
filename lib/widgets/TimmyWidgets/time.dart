import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:chat_app/controllers/saved_message.dart';

// ignore: must_be_immutable
class TimeWidget extends StatelessWidget {
  String time;
  int id;
  String message;
  TimeWidget(
      {required this.time,
      required this.id,
      required this.message,
      required this.onUpdateTime,
      super.key});
  final Function(String) onUpdateTime;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("Hora: $time",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary)),
      IconButton(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.only(left: 10),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor:
                                Theme.of(context).colorScheme.tertiary,
                            cardColor: Theme.of(context).colorScheme.tertiary,
                            canvasColor: Theme.of(context).colorScheme.tertiary,
                            dialogBackgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary:
                                        Theme.of(context).colorScheme.tertiary,
                                    onSurface: Theme.of(context).primaryColor)
                                .copyWith(
                                    background: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                        child: child!),
                  );
                },
                context: context,
                initialTime: TimeOfDay(
                    hour: int.parse(time.split(":")[0]),
                    minute: int.parse(time.split(":")[1])));

            if (pickedTime != null) {
              List<String> mess = message.split("/");

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

              if (mess[0] != "EDITING") {
                mess[5] = "$horas:$minutoss";
              } else {
                mess[3] = "$horas:$minutoss";
              }

              // mess[5] = "$horas:$minutoss";

              String messSt = mess.join("/");
              SavedMessage s = SavedMessage();

              await s.updateMessageTime(messSt, id);

              if (mess[0] != "EDITING") {
                onUpdateTime(mess[5]);
              } else {
                onUpdateTime(mess[3]);
              }
            }
          },
          icon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.tertiary,
          ))
    ]);
  }
}
