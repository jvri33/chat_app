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
    TimeOfDay ret = const TimeOfDay(hour: 0, minute: 0);
    for (int i = 0; i < entities.length; i++) {
      if (entities[i][2] == "TIME") {
        //print("time");
        //print(entities[i][0]);
        if (isNumeric(entities[i][0])) {
          int hora = int.parse(entities[i][0].toString());
          ret = TimeOfDay(hour: hora, minute: 0);
        }
      }
    }
    return ret;
  }

  DateTime? fecha(String d) {
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

      if (entities[i][2] == "MONTH") {
        month = getMonth(entities[i][0]);
      }
    }

    if (day == 0 && d == "e") {
      DateTime date = DateTime(0, 0, 0);
      return date;
    }

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
