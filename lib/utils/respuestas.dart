import 'package:chat_app/utils/extractor.dart';
import '../controllers/reminder.dart';
import 'package:chat_app/controllers/saved_message.dart';

class Respuesta {
  Respuesta();

  getResponse(i1, i2, i3) async {
    //i1 = Intent
    //i2 = entities
    //i3 = message

    Reminder delete = Reminder();

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
      List<String> str = (Extractor(i2).fecha("")).toString().split(" ");

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

      List<String> str = (Extractor(i2).fecha("")).toString().split(" ");

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

      List<String> str = (Extractor(i2).fecha("")).toString().split(" ");

      if ("$i2" == "[]") {
        ret2 = "EDIT1/NULL";
      } else {
        DateTime d = DateTime.parse(str[0]);
        ret2 = "EDIT1/${d.toString().split(" ")[0]}";
      }
    }
    if (i1 == "REMINDER1") {
      dig = "w";
      //MIRAMOS SI TIENE ENTIDADES
      if (i2 != "[]") {
        List<String> str = (Extractor(i2).fecha("")).toString().split(" ");

        DateTime d = DateTime.parse(str[0]);

        //DateTime time = DateTime.parse(str.join(" "));

        DateTime compare = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        //rint(time);
        if (d.isBefore(compare)) {
          dig = "m";
          ret2 = "No se pueden crear recordatorios en el pasado";
        } else {
          //int reminderId = await reminder.createItem(i3, d, 0, 0, "", "");

          //print(reminderId);

          ret2 =
              "$i3/${d.toString().split(" ")[0]}/${0}/${0}/${"days"}/${str[1].split(":")[0]}:${str[1].split(":")[1]}";
        }
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
