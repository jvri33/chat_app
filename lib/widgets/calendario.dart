import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/day.dart';
import 'package:flutter/material.dart';

import '../controllers/reminder.dart';

// ignore: must_be_immutable
class Calendario extends StatelessWidget {
  final Function() notifyParent;
  int day = DateTime.now().day;
  int mes = 7;
  int year = 2023;

  List<List<Map<String, dynamic>>> recordatorios = [];
  Reminder r = Reminder();
  Calendario(this.notifyParent, {super.key});
  List<List<int>> month = [];

  Future<void> getCalendar() async {
    DateTime d = DateTime.now();

    int thisDays = DateUtils.getDaysInMonth(d.year, d.month);
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
      m = "0$mes";
    } else {
      m = mes.toString();
    }

    recordatorios = await r.getItemsByMonth(m);

    recordatorios.insert(0, []);
  }

  Future<void> getReminders() async {
    Reminder r = Reminder();
    //print(mes);
    String m;
    if (mes < 10) {
      m = "0$mes";
    } else {
      m = mes.toString();
    }

    recordatorios = await r.getItemsByMonth(m);

    recordatorios.insert(0, []);
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
                      child: const Text(
                        "Aqui tienes el calendario:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
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
                              "Julio",
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
                                                    month[i][index] == day
                                                        ? Theme.of(context)
                                                            .primaryColor
                                                        : Colors.white)),
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
                                                      "2023-07-0${month[i][index]}";
                                                } else {
                                                  dateS =
                                                      "2023-07-${month[i][index]}";
                                                }
                                                String ret = "DAY/$dateS";
                                                await saveMessageController
                                                    .createItem(
                                                        ret.toString(), 0, dig);
                                                notifyParent();
                                              }
                                            : null,
                                        child: Container(
                                          color: month[i][index] == day
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
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
                                                fontWeight: FontWeight.w700,
                                                color: month[i][index] < day &&
                                                        month[i][index] > 0
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : month[i][index] != 0 &&
                                                            month[i][index] !=
                                                                day
                                                        ? Colors.black
                                                        : Colors.white),
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
