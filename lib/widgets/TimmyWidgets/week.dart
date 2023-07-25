import 'package:chat_app/controllers/reminder.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Week extends StatelessWidget {
  List<List<Map<String, dynamic>>> recordatorios = [];
  String mes;
  int cantidad = 0;
  int p = 0;
  int startl = 10;
  List<List<Widget>> ret = [];
  Week(this.mes, {super.key});
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  List<String> dias = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  Future<void> getReminders() async {
    DateTime date;
    if (mes == "THISWEEK") {
      date = DateTime.now();
    } else {
      date = DateTime.now().add(const Duration(days: 7));
    }

    Reminder r = Reminder();
    DateTime start = getDate(date.subtract(Duration(days: date.weekday - 1)));
    List<Map<String, dynamic>> recordatoriosh = [];
    for (int i = 0; i < 7; i++) {
      DateTime d = start.add(Duration(days: i));

      recordatoriosh = await r.getItemsByDay(d.toString().split(" ")[0]);
      if (recordatoriosh.isNotEmpty) {
        cantidad++;

        if (startl == 10) {
          startl = i;
        }
      }
      recordatorios.add(recordatoriosh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReminders(),
      builder: (context, snapshot) {
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
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 75.0,
              maxWidth: 300.0,
            ),
            child: Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
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
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: //Text("$dia, $dian de $mes",
                          Text(
                              mes == "THISWEEK"
                                  ? "Esta semana tienes todo esto:"
                                  : "La próxima semana tienes todo esto:",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(0))),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16),
                      margin: const EdgeInsets.only(right: 8, top: 12, left: 4),
                      child: cantidad == 0
                          ? const SizedBox(
                              width: 220,
                              child: Text(
                                "No tienes nada todavía.",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ))
                          : Column(
                              children:
                                  List.generate(recordatorios.length, (index) {
                                List<Widget> innerList = [];

                                for (int i = 0;
                                    i < recordatorios[index].length;
                                    i++) {
                                  innerList.add(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "${recordatorios[index][i]['description']}  ${recordatorios[index][i]['time']}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    ),
                                  );
                                }
                                if (recordatorios[index].isNotEmpty) {
                                  p++;
                                }
                                return Column(
                                  children: [
                                    if (recordatorios[index].isNotEmpty)
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              "${dias[index]}, ${recordatorios[index].toString().split("-")[2].split(",")[0]}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Theme.of(context)
                                                      .primaryColor))),
                                    Column(
                                      children: List.generate(
                                        innerList.length,
                                        (j) {
                                          return (Column(children: [
                                            innerList[j],
                                          ]));
                                        },
                                      ),
                                    ),
                                    if (index >= startl &&
                                        index != 6 &&
                                        recordatorios[index].isNotEmpty &&
                                        (recordatorios[index + 1].isNotEmpty))
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
              ),
            ),
          ),
        );
      },
    );
  }
}
