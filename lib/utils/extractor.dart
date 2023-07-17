import 'package:flutter/material.dart';

class Extractor {
  List entities;

  Extractor(this.entities) {
    //fecha();
    //hora();
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  TimeOfDay hora() {
    int tarde = 0;
    List<dynamic> times = [];
    for (int i = 0; i < entities.length; i++) {
      if (entities[i][2] == "TIME") {
        times.add(entities[i]);
      }

      if (entities[i][2] == "HORARIO") {
        if (entities[i][0] == "tarde" || entities[i][0] == "noche") {
          tarde = 12;
        }
      }
    }

    TimeOfDay ret = const TimeOfDay(hour: 0, minute: 0);
    for (int i = 0; i < times.length; i++) {
      //print("time");

      //print(entities[i][0]);
      if (times.length == 1 && isNumeric(times[i][0])) {
        int hora = int.parse(times[i][0].toString());
        ret = TimeOfDay(hour: hora + tarde, minute: 0);
      } else if (times.length > 1 && isNumeric(times[i][0])) {
        int hora = int.parse(times[i][0].toString());
        int min = int.parse(times[i + 1][0].toString());
        return ret = TimeOfDay(hour: hora + tarde, minute: min);
      } else {
        List<String> hhmm = times[i][0].toString().split(":");
        if (hhmm.length == 2) {
          ret = TimeOfDay(
              hour: int.parse(hhmm[0]) + tarde, minute: int.parse(hhmm[1]));
        }
      }
    }
    print(ret);

    return ret;
  }

  DateTime? fecha() {
    int day = 0;
    int month = 0;
    int dif = 0;
    for (int i = 0; i < entities.length; i++) {
      //print(entities[i]);
      if (entities[i][2] == "DAY") {
        //int n = int.parse(entities[i][0].toString());
        if (isNumeric(entities[i][0])) {
          day = int.parse(entities[i][0].toString());
        } else {
          if (entities[i][0] == "hoy" ||
              entities[i][0] == "mañana" ||
              entities[i][0] == "pasadomañana" ||
              entities[i][0] == "pasaomañana") {
            if (entities[i][0] == "hoy") {
              day = DateTime.now().day;
            }
            if (entities[i][0] == "mañana") {
              day = DateTime.now().day + 1;
            }
            if (entities[i][0] == "pasadomañana" ||
                entities[i][0] == "pasaomañana") {
              print("pasadomañana");

              day = DateTime.now().day + 2;
            }
          } else {
            String sday = entities[i][0];
            int iweekday = weekday(sday);
            int actual = (DateTime.now().weekday);

            if (iweekday < actual) {
              dif = 7 - actual + iweekday;
              //print("entra aqui");
            }
            if (actual < iweekday) {
              dif = iweekday - actual;
            }
            if (actual == iweekday) {
              dif = 7;
            }
          }
        }
      }

      if (entities[i][2] == "MONTH") {
        month = getMonth(entities[i][0]);
      }
    }

    /*if (day == 0) {
      DateTime date = DateTime(0, 0, 0);
      return date;
    }*/

    if (day == 0 && dif == 0) {
      day = DateTime.now().day;
    }
    if (dif > 0 && day == 0) {
      day = DateTime.now().add(Duration(days: dif)).day;
    }
    if (month == 0) {
      if (day < DateTime.now().day) {
        month = DateTime.now().month + 1;
      } else {
        month = DateTime.now().month;
      }
    }

    int year = DateTime.now().year;
    DateTime time = DateTime.now();
    DateTime date = DateTime(year, month, day, time.hour, time.minute);

    print("date $date");

    return date;
  }

  int getMonth(m) {
    int ret = 0;
    List months = [
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

    for (var i in months) {
      if (i == m) {
        ret = months.indexOf(i) + 1;
      }
    }
    //print(ret);
    return ret;
  }

  int weekday(s) {
    int ret = 0;
    List days = [
      "lunes",
      "martes",
      "miercoles",
      "jueves",
      "viernes",
      "sabado",
      "domingo"
    ];
    for (var i in days) {
      if (s == i) {
        ret = days.indexOf(i) + 1;
      }
    }
    return ret;
  }
}
