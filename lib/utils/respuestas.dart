import 'package:chat_app/utils/extractor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app/controllers/saved_message.dart';

class Respuesta {
  Respuesta();

  getResponse(i1, i2, i3) async {
    //i1 = Intent
    //i2 = entities
    //i3 = message

    print(i2);

    //Reminder delete = Reminder();

    //delete.deleteall();

    String ret2 = "";
    String dig = "m";
    SavedMessage saveMessageController = SavedMessage();

    if (i1 == "NEXTWEEK0") {
      dig = "we";
      ret2 = "NEXTWEEK";
    }
    if (i1 == "THISWEEK0") {
      dig = "we";
      ret2 = "THISWEEK";
    }

    if (i1 == "DAY1") {
      List<String> str = (Extractor(i2).fecha()).toString().split(" ");

      if ("$i2" == "[]") {
        ret2 = "DAY/NULL";
      } else {
        DateTime d = DateTime.parse(str[0]);
        ret2 = "DAY/${d.toString().split(" ")[0]}";
      }

      dig = "i";
    }

    if (i1 == "DELETE1") {
      ret2 = "Borrar recordatorio";
      dig = "d";

      List<String> str = (Extractor(i2).fecha()).toString().split(" ");

      if ("$i2" == "[]") {
        ret2 = "DELETE1/NULL";
      } else {
        DateTime d = DateTime.parse(str[0]);
        ret2 = "DELETE1/${d.toString().split(" ")[0]}";
      }
    }

    //COMPROBAMOS LA INTECION
    if (i1 == "EDIT1") {
      dig = "e";
      ret2 = "Editar recordatorio";

      List<String> str = (Extractor(i2).fecha()).toString().split(" ");

      if ("$i2" == "[]") {
        ret2 = "EDIT1/NULL";
      } else {
        DateTime d = DateTime.parse(str[0]);
        ret2 = "EDIT1/${d.toString().split(" ")[0]}";
      }
    }
    if (i1 == "REMINDER1") {
      bool hoy = false;
      dig = "w";
      bool horario = false;
      //MIRAMOS SI TIENE ENTIDADES
      if (i2 != "[]") {
        for (int i = 0; i < i2.length; i++) {
          if (i2[i][2] == "HORARIO") {
            horario = true;
          }
        }

        if (i2 != "[]") {
          for (int i = 0; i < i2.length; i++) {
            print(i2[i]);
            if (i2[i][0] == "hoy") {
              print(i2[i]);
              hoy = true;
            }
          }
        }
        List<String> str = (Extractor(i2).fecha()).toString().split(" ");

        TimeOfDay str2 = (Extractor(i2).hora());

        DateTime d = DateTime.now();
        String hour = str2.hour.toString();
        String minute = str2.minute.toString();
        if (str2.minute < 10) {
          minute = "0${str2.minute}";
        }
        if (str2.hour < 10) {
          hour = "0${str2.hour}";
        }
        if (int.parse(hour) > 23 ||
            int.parse(hour) < 1 ||
            int.parse(minute) > 59 ||
            int.parse(minute) < 0) {
          hour = d.hour.toString();
          minute = d.minute.toString();
        }
        d = DateTime.parse("${str[0]} $hour:$minute:00");
        print(d);

        DateTime compare = DateTime.now();
        //rint(time);
        if (d.isBefore(compare) && !hoy) {
          DateTime doce =
              DateTime(d.year, d.month, d.day, d.hour + 12, d.minute);

          if (doce.isAfter(DateTime.now()) && !horario) {
            hour = (str2.hour + 12).toString();
          } else {
            ret2 =
                "Se ha creado el siguiente borrador de recordatorio pero para mañana.";
            d = DateTime(d.year, d.month, d.day + 1, d.hour, d.minute);

            if (d.isBefore(compare)) {
              dig = "m";
              ret2 = "No se pueden crear recordatorios en el pasado";

              await saveMessageController.createItem(ret2.toString(), 0, dig);
              //await f();
              return ret2.toString();
            }
          }
        }
        if (d.isBefore(compare)) {
          dig = "m";
          ret2 = "No se pueden crear recordatorios en el pasado";

          await saveMessageController.createItem(ret2.toString(), 0, dig);
          //await f();
          return ret2.toString();
        }
        //int reminderId = await reminder.createItem(i3, d, 0, 0, "", "");

        //print(reminderId);

        ret2 =
            "$i3/${d.toString().split(" ")[0]}/${0}/${0}/${"days"}/$hour:$minute";

        //ESTO ES LO QUE DEVUELVE EL METODO DE CREAR

        //reminder.delete();
      }
    }

    if (i1 == "CALENDAR0") {
      dig = "c";
      ret2 = "CALENDAR/";
      List t = i2;
      for (int i = 0; i < t.length; i++) {
        if (t[i][2] == "MONTH") {
          ret2 = "CALENDAR/${t[i][0]}";
        }
      }
    }

    if (i3 == "ayuda" || i3 == "Ayuda") {
      SharedPreferences s = await SharedPreferences.getInstance();
      s.setBool("first_time", true);

      ret2 = "Ayuda";
    }

    //print(i2.isNotEmpty);
    if (ret2 == "") {
      ret2 =
          "Lo siento, no te he entendido, intenta expresarte de otra manera :)";
    }

    await saveMessageController.createItem(ret2.toString(), 0, dig);
    //await f();
    return ret2.toString();

    //para verificar las intenciones devolver i1
  }
}
