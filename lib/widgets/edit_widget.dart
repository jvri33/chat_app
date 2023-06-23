import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/date.dart';
import 'package:chat_app/widgets/repeticion.dart';
import 'package:chat_app/widgets/sound.dart';
import 'package:chat_app/widgets/time.dart';
import 'package:flutter/material.dart';
import '../controllers/reminder.dart';

// ignore: must_be_immutable
class EditWidget extends StatefulWidget {
  final Function() notifyParent;
  String response =
      "He encontrado el siguiente recordatorio en la fecha que indicas:";
  final int user;
  String message;
  final int id;
  bool state = false;
  late int cantidad = 0;
  late List<String> variables;

  List<Map<String, dynamic>> recordatorios = [];
  EditWidget(this.user, this.message, this.id, this.notifyParent, {super.key}) {
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
    if (variables[0] == "EDIT1") {
      String date = widget.message.split("/")[1];

      if (date != "-0001-11-30") {
        Reminder r = Reminder();
        widget.recordatorios = await r.getItemsByDay(date);

        print("obtenemos los recordatorio por día");

        widget.cantidad = widget.recordatorios.length;

        if (widget.cantidad == 1) {
          print("Hay un recordatorio");
          widget.message =
              "EDITING/${widget.recordatorios[0]["id"]}/${widget.recordatorios[0]["date"]}/${widget.recordatorios[0]["time"]}/${widget.recordatorios[0]["sound"]}/${widget.recordatorios[0]["repeat"]}/${widget.recordatorios[0]["description"]}";
          SavedMessage s = SavedMessage();
          await s.updateMessage(widget.message, widget.id, "e");
          variables = widget.message.split("/");
          print("mensaje actualizado en getReminders");
        } else if (widget.cantidad == 0) {
          print("No hay recordatorios");
        } else {
          print("Hay más de un recordatorio");
        }
      }
    }
    print("finish en metodo");
    return "finish";
  }

  //Se ha creado?

  void updateDate(String newDate) {
    print("new date $newDate");
    setState(() {
      print("set state");
      variables[2] = newDate;
    });
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
          //variables = widget.message.split("/");
          //print(variables[2]);
          print("widget cantidad: ${widget.message}");
          if (widget.state == false) {
            if (variables[0] == "EDITING") {
              print(variables);

              return Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(200))),
                alignment:
                    widget.user == 1 ? Alignment.topRight : Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 75.0,
                    maxWidth: 320.0,
                  ),
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            bottomRight: widget.user == 0
                                ? const Radius.circular(16)
                                : const Radius.circular(0),
                            topRight: const Radius.circular(16),
                            bottomLeft: widget.user == 1
                                ? const Radius.circular(16)
                                : const Radius.circular(0)),
                      ),
                      color: widget.user == 1
                          ? const Color.fromARGB(255, 187, 247, 223)
                          : Theme.of(context).primaryColor,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                          child: widget.state == false
                              ? Column(
                                  children: [
                                    Text(widget.response,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: widget.user == 1
                                                ? Theme.of(context).primaryColor
                                                : Colors.white)),
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
                                                    message: "",
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

                                                  print(
                                                      "variables ${variables}");

                                                  await rem.updateReminder(
                                                      int.parse(variables[1]),
                                                      variables[6],
                                                      variables[2],
                                                      int.parse(variables[4]),
                                                      int.parse(variables[5]),
                                                      "days",
                                                      variables[3]);

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
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: widget.user == 1
                                          ? Theme.of(context).primaryColor
                                          : Colors.white)))),
                ),
              );
            } else {
              if (widget.cantidad > 1) {
                //return Text("Hay más de un recordatorio ese día. Elige uno");

                return Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200))),
                  alignment:
                      widget.user == 1 ? Alignment.topRight : Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 75.0,
                      maxWidth: 320.0,
                    ),
                    child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              bottomRight: widget.user == 0
                                  ? const Radius.circular(16)
                                  : const Radius.circular(0),
                              topRight: const Radius.circular(16),
                              bottomLeft: widget.user == 1
                                  ? const Radius.circular(16)
                                  : const Radius.circular(0)),
                        ),
                        color: widget.user == 1
                            ? const Color.fromARGB(255, 187, 247, 223)
                            : Theme.of(context).primaryColor,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            child: widget.state == false
                                ? Column(
                                    children: [
                                      Text(
                                          "Hay más de 1 recordatorio. Elige el que quieres modificar:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: widget.user == 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white)),
                                      Container(

                                          //Aquí empieza el contenido
                                          child: Container(
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
                                            children: List.generate(
                                                widget.cantidad, (index) {
                                          return (TextButton(
                                            child: Text(
                                                "${index + 1}. ${widget.recordatorios[index]['description']}  ${widget.recordatorios[index]['time']}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                            onPressed: () {},
                                          ));
                                        })),
                                      ))
                                    ],
                                  )
                                : Text(widget.message,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: widget.user == 1
                                            ? Theme.of(context).primaryColor
                                            : Colors.white)))),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              bottomRight: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: const Radius.circular(0)),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                          child: Text("No hay recordatorios",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        )),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          bottomRight: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: const Radius.circular(0)),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16),
                      child: Text(widget.message,
                          style: TextStyle(
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
