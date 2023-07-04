import 'package:chat_app/controllers/saved_message.dart';

import 'package:flutter/material.dart';

import '../TimmyWidgets/date.dart';
import '../TimmyWidgets/repeticion.dart';
import '../TimmyWidgets/sound.dart';
import '../TimmyWidgets/time.dart';

import '../../controllers/notification_service.dart';
import '../../controllers/reminder.dart';

// ignore: must_be_immutable
class EditWidget extends StatefulWidget {
  final Function() notifyParent;
  String response =
      "He encontrado el siguiente recordatorio en la fecha que indicas:";

  String message;
  final int id;
  bool state = false;
  late int cantidad = 0;
  late List<String> variables;

  List<Map<String, dynamic>> recordatorios = [];
  EditWidget(this.message, this.id, this.notifyParent, {super.key}) {
    if (message == "Se ha editado el recordatorio correctamente") {
      state = true;
    }
  }

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
  late List<String> variables = widget.message.split("/");

  Future<String> getReminders() async {
    //print(variables.toString());

    if (variables[0] == "EDIT1") {
      String date = variables[1];

      if (date != "-0001-11-30") {
        Reminder r = Reminder();
        widget.recordatorios = await r.getItemsByDay(date);

        widget.cantidad = widget.recordatorios.length;

        if (widget.cantidad == 1) {
          widget.message =
              "EDITING/${widget.recordatorios[0]["id"]}/${widget.recordatorios[0]["date"]}/${widget.recordatorios[0]["time"]}/${widget.recordatorios[0]["sound"]}/${widget.recordatorios[0]["repeat"]}/${widget.recordatorios[0]["description"]}";
          SavedMessage s = SavedMessage();
          await s.updateMessage(widget.message, widget.id, "e");
          variables = widget.message.split("/");
        }
      }
    }

    return "finish";
  }

  void updateDate(String newDate) {
    if (variables[0] == "EDIT1") {
      setState(() {
        variables[1] = newDate;
      });
    } else {
      variables[2] = newDate;
      setState(() {});
    }
  }

  void updateTime(String newTime) {
    setState(() {
      variables[3] = newTime;
    });
  }

  void updateSound(String newSound) {
    setState(() {
      variables[4] = newSound;
    });
  }

  void updateRepeat(String newRepeat) {
    setState(() {
      variables[5] = newRepeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (FutureBuilder(
        future: getReminders(),
        builder: (context, snapshot) {
          if (widget.state == false) {
            if (variables[0] == "EDITING") {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(200))),
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 75.0,
                    maxWidth: 320.0,
                  ),
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(0)),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                          child: widget.state == false
                              ? Column(
                                  children: [
                                    Text(widget.response,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20.0),

                                      //Aquí empieza el contenido
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 8, top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                DateWidget(
                                                  date: variables[2],
                                                  id: widget.id,
                                                  message: widget.message,
                                                  onUpdateDate: updateDate,
                                                ),
                                                TimeWidget(
                                                  time: variables[3],
                                                  id: widget.id,
                                                  message: widget.message,
                                                  onUpdateTime: updateTime,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 17, top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SoundWidget(
                                                    sound:
                                                        int.parse(variables[4]),
                                                    id: widget.id,
                                                    message: widget.message,
                                                    onUpdateSound: updateSound),
                                                RepeatWidget(
                                                  repeat:
                                                      int.parse(variables[5]),
                                                  id: widget.id,
                                                  message: widget.message,
                                                  onUpdateRepeat: updateRepeat,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 8, top: 8),
                                            child: Row(children: [
                                              SizedBox(
                                                width: 230,
                                                child: Text(
                                                    "Nombre: ${variables[6]}",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white)),
                                              )
                                            ]),
                                          ),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                constraints:
                                                    const BoxConstraints(),
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                onPressed: () async {
                                                  Reminder rem = Reminder();

                                                  await rem.updateReminder(
                                                      int.parse(variables[1]),
                                                      variables[6],
                                                      variables[2],
                                                      int.parse(variables[5]),
                                                      int.parse(variables[4]),
                                                      "days",
                                                      variables[3]);

                                                  await NotiticationService()
                                                      .cancelNotification(
                                                          int.parse(
                                                              variables[1]));

                                                  NotiticationService()
                                                      .scheduleNotification(
                                                          sound: variables[4] ==
                                                              "1",
                                                          id: int.parse(
                                                              variables[5]),
                                                          title: "Recordatorio",
                                                          body: variables[6],
                                                          scheduledNotificationDateTime:
                                                              DateTime.parse(
                                                                  "${variables[2]} ${variables[3]}"));

                                                  SavedMessage s =
                                                      SavedMessage();

                                                  widget.message =
                                                      "Se ha editado el recordatorio correctamente";
                                                  await s.updateMessage(
                                                      widget.message,
                                                      widget.id,
                                                      "e");

                                                  setState(() {
                                                    widget.state = true;
                                                    widget.response =
                                                        "Se ha editado el recordatorio correctamente";
                                                  });
                                                  widget.notifyParent();
                                                },
                                                icon: const Icon(Icons.check),
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Text(widget.message,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)))),
                ),
              );
            } else {
              if (widget.cantidad > 1) {
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200))),
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 75.0,
                      maxWidth: 320.0,
                    ),
                    child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(0)),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            child: widget.state == false
                                ? Column(
                                    children: [
                                      const Text(
                                          "Hay más de 1 recordatorio. Elige el que quieres modificar:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(0)),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: List.generate(
                                                widget.cantidad, (index) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: (TextButton(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "${index + 1}. ${widget.recordatorios[index]['description']}  ${widget.recordatorios[index]['time']}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                      ),
                                                      onPressed: () async {
                                                        widget.message =
                                                            "EDITING/${widget.recordatorios[index]["id"]}/${widget.recordatorios[index]["date"]}/${widget.recordatorios[index]["time"]}/${widget.recordatorios[index]["sound"]}/${widget.recordatorios[index]["repeat"]}/${widget.recordatorios[index]["description"]}";
                                                        SavedMessage s =
                                                            SavedMessage();
                                                        await s.updateMessage(
                                                            widget.message,
                                                            widget.id,
                                                            "e");

                                                        setState(() {
                                                          variables = widget
                                                              .message
                                                              .split("/");
                                                        });
                                                      },
                                                    )),
                                                  ),
                                                  if (index + 1 <
                                                      widget.cantidad)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Divider(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                ],
                                              );
                                            })),
                                      )
                                    ],
                                  )
                                : Text(widget.message,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)))),
                  ),
                );
              } else {
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200))),
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 75.0,
                      maxWidth: 300.0,
                    ),
                    child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(0)),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            child: Text(
                                variables[1] == "NULL"
                                    ? "Especifique una fecha en la que se hayan creado recordatorios:"
                                    : "No se han encontrado recordatorios el día ${variables[1]}, especifique otra fecha.",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 24, bottom: 10),
                                child: DateWidget(
                                    date: variables[1] == "NULL"
                                        ? DateTime.now()
                                            .toString()
                                            .split(" ")[0]
                                        : variables[1],
                                    id: widget.id,
                                    message: widget.message,
                                    onUpdateDate: updateDate),
                              )
                            ],
                          ),
                          /*IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(left: 10),
                            onPressed: () async {
                              SavedMessage s = SavedMessage();

                              print(variables[1]);
                              widget.message = "EDIT1/${variables[1]}";
                              await s.updateMessage(
                                  widget.message, widget.id, "e");

                              setState(() {
                                variables = widget.message.split("/");
                              });
                            },
                            icon: const Icon(Icons.check),
                            color: Colors.white,
                          )*/
                        ])),
                  ),
                );
              }
            }
          } else {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 75.0,
                  maxWidth: 300.0,
                ),
                child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(0)),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16),
                      child: Text(widget.message,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    )),
              ),
            );
          }
        }));
  }
}
