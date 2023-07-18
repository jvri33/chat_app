import 'dart:ui';

import 'package:chat_app/controllers/saved_message.dart';

import 'package:flutter/material.dart';

import '../TimmyWidgets/date.dart';

import '../../controllers/notification_service.dart';
import '../../controllers/reminder.dart';

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
          widget.message =
              "DELETING/${widget.recordatorios[0]["id"]}/${widget.recordatorios[0]["date"]}/${widget.recordatorios[0]["time"]}/${widget.recordatorios[0]["sound"]}/${widget.recordatorios[0]["repeat"]}/${widget.recordatorios[0]["description"]}";
          SavedMessage s = SavedMessage();
          await s.updateMessage(widget.message, widget.id, "d");
          variables = widget.message.split("/");
        }
      }
    }

    return "finish";
  }

  void _showDeleteConfirmationDialog() {
    showGeneralDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      context: context,
      transitionBuilder: (BuildContext context, a1, a2, w) {
        final curvedAnimation = CurvedAnimation(
            parent: a1,
            curve: Curves.fastOutSlowIn); // Ajusta la curva de animación aquí
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              title: Text(
                'Confirmar eliminación',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800),
              ),
              content: const Text(
                  '¿Estás seguro de que deseas eliminar el recordatorio?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Eliminar',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  onPressed: () async {
                    // Aquí puedes realizar las acciones de eliminación y actualizar el estado
                    Reminder r = Reminder();
                    SavedMessage s = SavedMessage();

                    await r.delete(int.parse(variables[1]));
                    await NotiticationService()
                        .cancelNotification(int.parse(variables[1]));

                    widget.message =
                        'Se ha borrado el recordatorio correctamente';
                    await s.updateMessage(widget.message, widget.id, 'd');

                    setState(() {
                      variables = widget.message.split('/');
                      widget.state = true;
                    });

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                                    Text(
                                        "Desea eliminar el siguiente recordatorio?",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary)),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8.0, top: 8, right: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(12)),
                                      ),

                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            width: 220,
                                            child: Text(
                                              "${variables[2]} | ${variables[6]}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                          IconButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              onPressed:
                                                  _showDeleteConfirmationDialog,
                                              /*
                                                Reminder r = Reminder();
                                                SavedMessage s = SavedMessage();

                                                await r.delete(
                                                    int.parse(variables[1]));
                                                await NotiticationService()
                                                    .cancelNotification(
                                                        int.parse(
                                                            variables[1]));

                                                widget.message =
                                                    "Se ha borrado el recordatorio correctamente";
                                                await s.updateMessage(
                                                    widget.message,
                                                    widget.id,
                                                    "d");

                                                setState(() {
                                                  variables =
                                                      widget.message.split("/");

                                                  widget.state = true;
                                                });
                                              */
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                      //Aquí empieza el contenido
                                    ),
                                  ],
                                )
                              : Text(widget.message,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)))),
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
                                      Text(
                                          "Hay más de 1 recordatorio. Elige el que quieres borrar:",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary)),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          borderRadius: const BorderRadius.only(
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
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)))),
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
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
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
                            color: Theme.of(context).colorScheme.tertiary,
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
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.tertiary)),
                    )),
              ),
            );
          }
        }));
  }
}
