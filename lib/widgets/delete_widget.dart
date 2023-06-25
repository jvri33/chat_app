import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/date.dart';

import 'package:flutter/material.dart';
import '../controllers/reminder.dart';

// ignore: must_be_immutable
class DeleteWidget extends StatefulWidget {
  final Function() notifyParent;
  String response =
      "He encontrado el siguiente recordatorio en la fecha que indicas:";

  String message;
  final int id;
  bool state = false;
  late int cantidad = 0;
  late List<String> variables;

  List<Map<String, dynamic>> recordatorios = [];
  DeleteWidget(this.message, this.id, this.notifyParent, {super.key}) {
    if (message == "Se ha borrado el recordatorio correctamente") {
      state = true;
    }
  }

  @override
  State<DeleteWidget> createState() => _DeleteWidgetState();
}

class _DeleteWidgetState extends State<DeleteWidget> {
  late List<String> variables = widget.message.split("/");

  Future<String> getReminders() async {
    //print(variables.toString());

    if (variables[0] == "DELETE1") {
      String date = variables[1];

      if (date != "NULL") {
        Reminder r = Reminder();
        widget.recordatorios = await r.getItemsByDay(date);

        widget.cantidad = widget.recordatorios.length;

        if (widget.cantidad == 1) {
          print("Hay un recordatorio");
          widget.message =
              "DELETING/${widget.recordatorios[0]["id"]}/${widget.recordatorios[0]["date"]}/${widget.recordatorios[0]["time"]}/${widget.recordatorios[0]["sound"]}/${widget.recordatorios[0]["repeat"]}/${widget.recordatorios[0]["description"]}";
          SavedMessage s = SavedMessage();
          await s.updateMessage(widget.message, widget.id, "d");
          variables = widget.message.split("/");
        } else if (widget.cantidad == 0) {
          print("No hay recordatorios");
        } else {
          print("Hay más de un recordatorio");
        }
      }
    }

    return "finish";
  }

  void updateDate(String newDate) {
    setState(() {
      variables[1] = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (FutureBuilder(
        future: getReminders(),
        builder: (context, snapshot) {
          if (widget.state == false) {
            if (variables[0] == "DELETING") {
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
                              vertical: 16.0, horizontal: 4),
                          child: widget.state == false
                              ? Column(
                                  children: [
                                    const Text(
                                        "Desea eliminar el siguiente recordatorio?",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0, top: 8, right: 6),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(12)),
                                      ),

                                      child: Row(
                                        children: [
                                          Text(
                                            "      ${variables[2]} | ${variables[6]}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          IconButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              onPressed: () async {
                                                Reminder r = Reminder();
                                                SavedMessage s = SavedMessage();

                                                await r.delete(
                                                    int.parse(variables[1]));

                                                widget.message =
                                                    "Se ha borrado el recordatorio correctamente";
                                                await s.updateMessage(
                                                    widget.message,
                                                    widget.id,
                                                    "d");

                                                setState(() {
                                                  variables =
                                                      widget.message.split("/");

                                                  print(variables);
                                                  widget.state = true;
                                                });
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                      //Aquí empieza el contenido
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
                                          "Hay más de 1 recordatorio. Elige el que quieres borrar:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                      Container(
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
                                          return Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: (TextButton(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        "${index + 1}. ${widget.recordatorios[index]['description']}  ${widget.recordatorios[index]['time']}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)),
                                                  ),
                                                  onPressed: () async {
                                                    widget.message =
                                                        "DELETING/${widget.recordatorios[index]["id"]}/${widget.recordatorios[index]["date"]}/${widget.recordatorios[index]["time"]}/${widget.recordatorios[index]["sound"]}/${widget.recordatorios[index]["repeat"]}/${widget.recordatorios[index]["description"]}";
                                                    SavedMessage s =
                                                        SavedMessage();

                                                    await s.updateMessage(
                                                        widget.message,
                                                        widget.id,
                                                        "d");

                                                    setState(() {
                                                      variables = widget.message
                                                          .split("/");
                                                    });
                                                  },
                                                )),
                                              ),
                                              if (index + 1 < widget.cantidad)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
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
                                    : "No se han encontrado recordatorio el día ${variables[1]}, especifique otra fecha.",
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
                          /* IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(left: 10),
                            onPressed: () async {
                              SavedMessage s = SavedMessage();

                              print(variables[1]);
                              widget.message = "DELETE1/${variables[1]}";
                              await s.updateMessage(
                                  widget.message, widget.id, "d");

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
