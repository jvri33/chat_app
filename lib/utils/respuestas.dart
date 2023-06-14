import 'package:chat_app/utils/extractor.dart';

import 'package:chat_app/controllers/saved_message.dart';

class Respuesta {
  Respuesta();

  getResponse(i1, i2, i3) async {
    //i1 = Intent
    //i2 = entities
    //i3 = message

    //
    //Reminder delete = Reminder();
    //delete.delete();

    print(i1);
    print(i2);
    print(i3);
    String ret2 = "";
    String dig = "m";
    SavedMessage saveMessageController = SavedMessage();

    //COMPROBAMOS LA INTECION

    if (i1 == "REMINDER1") {
      dig = "w";
      //MIRAMOS SI TIENE ENTIDADES
      if (i2 != "[]") {
        List<String> str = (Extractor(i2).fecha()).toString().split(" ");

        DateTime d = DateTime.parse(str[0]);

        if (d.isBefore(DateTime.now())) {
          dig = "m";
          ret2 = "No se pueden crear recordatorio en el pasado";
        } else {
          //int reminderId = await reminder.createItem(i3, d, 0, 0, "", "");

          //print(reminderId);

          ret2 =
              "$i3/${d.toString().split(" ")[0]}/${0}/${0}/${"days"}/${"00:00"}";
        }
        //ESTO ES LO QUE DEVUELVE EL METODO DE CREAR

        //reminder.delete();
      }
    }

    if (i1 == "CALENDAR0") {
      dig = "c";
      print("calendar intent");
    }

    //print(i2.isNotEmpty);

    await saveMessageController.createItem(ret2.toString(), 0, dig);
    return ret2.toString();

    //para verificar las intenciones devolver i1
  }
}
