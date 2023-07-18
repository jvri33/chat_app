import 'package:chat_app/controllers/saved_message.dart';

import 'package:flutter/material.dart';

import '../../controllers/reminder.dart';

// ignore: must_be_immutable
class Calendario extends StatelessWidget {
  final String message;
  final int id;
  final Function() notifyParent;
  int day = DateTime.now().day;
  int mes = 0;
  int year = 2023;
  int actualmes = DateTime.now().month;
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
  List<List<Map<String, dynamic>>> recordatorios = [];
  Reminder r = Reminder();
  Calendario(this.message, this.id, this.notifyParent, {super.key}) {
    if (message.split("/")[1] != "") {
      for (int i = 0; i < meses.length; i++) {
        if (meses[i] == (message.split("/")[1].toLowerCase())) {
          mes = i;
        }
      }
    } else {
      mes = actualmes - 1;
    }
    //print(message);
  }
  List<List<int>> month = [];

  Future<void> getCalendar() async {
    DateTime de = DateTime.now();

    DateTime d = DateTime(de.year, mes + 1, 1);

    int thisDays = DateUtils.getDaysInMonth(d.year, mes + 1);
    //Estas lineas son en caso de implementar que se van los dias anteriores y posteriores al mes seleccionado
    //int previous_days = DateUtils.getDaysInMonth(d.year, d.month - 1);
    //int future_days = DateUtils.getDaysInMonth(d.year, d.month + 1);
    DateTime firstday = DateTime(d.year, d.month, 1);
    //DateTime lastday = DateTime(d.year, d.month, this_days);

    //print(firstday.weekday);
    //print(lastday.weekday);

    List<int> line = [0, 0, 0, 0, 0, 0, 0];
    bool saved = false;
    line[firstday.weekday] = 1;
    int count = 0;
    int start = firstday.weekday - 1;
    for (int i = 1; i <= thisDays; i++) {
      saved = false;
      line[start + count] = i;
      count++;

      if (start + count == 7) {
        month.add(line);
        line = [0, 0, 0, 0, 0, 0, 0];
        start = 0;
        count = 0;
        saved = true;
      }
    }

    if (saved == false) {
      month.add(line);
    }

    //print("carga finalizada");
    Reminder r = Reminder();
    //print(mes);
    String m;
    if (mes < 10) {
      m = "0${mes + 1}";
    } else {
      m = {mes + 1}.toString();
    }

    recordatorios = await r.getItemsByMonth(m);

    recordatorios.insert(0, []);

    //print(recordatorios);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getCalendar(),
      builder: (context, snapshot) {
        //print("late builder");
        if (snapshot.connectionState != ConnectionState.done) {
          // Mientras se está cargando el calendario, puedes mostrar un indicador de carga o cualquier otro widget
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: const EdgeInsets.all(10),
                width: 30,
                height: 30,
                child: const CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Si hay un error durante la carga, puedes mostrar un mensaje de error
          return const Text('Error al cargar el calendario');
        }
        return Container(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 324),
            child: Card(
              color: Theme.of(context).primaryColor,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Aqui tienes el calendario:",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(0)),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 10.0, left: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              meses[mes],
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                              children: List.generate(month.length, (i) {
                            return Row(
                              children: List.generate(
                                7,
                                (index) {
                                  return SizedBox(
                                    width: 34,
                                    height: 30,
                                    child: (TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    mes + 1 == actualmes &&
                                                            month[i][index] ==
                                                                day
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .tertiary)),
                                        onPressed: month[i][index] > 0 &&
                                                recordatorios[month[i][index]]
                                                    .isNotEmpty
                                            ? () async {
                                                SavedMessage
                                                    saveMessageController =
                                                    SavedMessage();
                                                String dig = "i";
                                                String dateS = "";
                                                if (day < 10) {
                                                  dateS =
                                                      "2023-0${mes + 1}-0${month[i][index]}";
                                                } else {
                                                  dateS =
                                                      "2023-0${mes + 1}-${month[i][index]}";
                                                }
                                                String ret = "DAY/$dateS";
                                                await saveMessageController
                                                    .createItem(
                                                        ret.toString(), 0, dig);
                                                notifyParent();
                                              }
                                            : null,
                                        child: Container(
                                          color: mes + 1 == actualmes &&
                                                  month[i][index] == day
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                          child: Text(
                                            month[i][index].toString(),
                                            style: TextStyle(
                                                decoration: recordatorios
                                                            .isNotEmpty &&
                                                        recordatorios[month[i]
                                                                [index]]
                                                            .isNotEmpty
                                                    ? TextDecoration.underline
                                                    : TextDecoration.none,
                                                fontSize: 13,
                                                decorationThickness: 3,
                                                fontWeight: FontWeight.w700,
                                                color: (month[i][index] < day &&
                                                            month[i][index] >
                                                                0) ||
                                                        (mes + 1 != actualmes &&
                                                            month[i][index] !=
                                                                0)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : month[i][index] != 0 &&
                                                            month[i][index] !=
                                                                day
                                                        ? Colors.black
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .tertiary),
                                          ),
                                        ))),
                                  );
                                },
                              ),
                            );
                          })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
