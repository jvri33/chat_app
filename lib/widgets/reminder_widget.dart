import 'package:chat_app/widgets/date.dart';
import 'package:chat_app/widgets/repeticion.dart';
import 'package:chat_app/widgets/sound.dart';
import 'package:chat_app/widgets/time.dart';
import 'package:flutter/material.dart';

class ReminderWidget extends StatelessWidget {
  final int user;
  final String message;
  final int id;

  // ignore: use_key_in_widget_constructors
  ReminderWidget(this.user, this.message, this.id);
  late List<String> variables = message.split("/");

  set setFecha(String f) {
    variables[1] = f;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
      alignment: user == 1 ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 75.0,
          maxWidth: 320.0,
        ),
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  bottomRight: user == 0
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  topRight: const Radius.circular(16),
                  bottomLeft: user == 1
                      ? const Radius.circular(16)
                      : const Radius.circular(0)),
            ),
            color: user == 1
                ? const Color.fromARGB(255, 187, 247, 223)
                : Theme.of(context).primaryColor,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                        "Se ha creado un recordatorio el día X a las X, deseas modificarlo?",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: user == 1
                                ? Theme.of(context).primaryColor
                                : Colors.white)),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              DateWidget(
                                  date: variables[1], id: id, message: message),
                              TimeWidget(time: variables[5])
                            ],
                          ),
                          Row(
                            children: [
                              SoundWidget(sound: int.parse(variables[2])),
                              RepeatWidget(repeat: int.parse(variables[3])),
                            ],
                          ),
                          Row(children: [
                            Text("Nombre: ${variables[0]}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white))
                          ]),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: const EdgeInsets.only(left: 10),
                                onPressed: () {},
                                icon: Icon(Icons.check),
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
