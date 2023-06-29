import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../controllers/reminder.dart';
import '../controllers/saved_message.dart';

// ignore: must_be_immutable
class DayWidget extends StatelessWidget {
  String message;
  int id;
  int cantidad = 0;
  String dia = "";
  String dian = "";
  String mes = "";
  List<Map<String, dynamic>> recordatorios = [];
  DayWidget(this.message, this.id, {super.key});

  late List<String> variables = message.split("/");

  Future<String> getReminders() async {
    //print(variables.toString());

    if (variables[0] == "DAY") {
      String date = variables[1];
      DateTime? d = DateTime.tryParse(date);
      dian = variables[1].split("-")[2];
      List<String> dias = [
        "Lunes",
        "Martes",
        "Miércoles",
        "Jueves",
        "Viernes",
        "Sábado",
        "Domingo"
      ];

      List<String> meses = [
        "enero",
        "febrero",
        "marzo",
        "abril",
        "mayo",
        "junio",
        "julio",
        "agosto",
        "septiembre",
        "octubre",
        "noviembre",
        "diciembre"
      ];
      mes = meses[int.parse(variables[1].split("-")[1]) - 1];
      dia = dias[d!.weekday - 1];

      if (date != "NULL") {
        Reminder r = Reminder();
        recordatorios = await r.getItemsByDay(date);

        cantidad = recordatorios.length;
      }
    }

    return "finish";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getReminders(),
        builder: (context, snapshot) {
          if (cantidad == 0) {
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
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                      child: Text("No hay recordatorios.",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    )),
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
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("$dia, $dian de $mes",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(0))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16),
                            margin: const EdgeInsets.only(
                                right: 8, top: 12, left: 4),
                            child: Column(
                              children: List.generate(cantidad, (index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "${index + 1}. ${recordatorios[index]['description']}  ${recordatorios[index]['time']}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    ),
                                    if (index + 1 < cantidad)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Divider(
                                          color: Theme.of(context).primaryColor,
                                          thickness: 1,
                                        ),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            );
          }
        });
  }
}
