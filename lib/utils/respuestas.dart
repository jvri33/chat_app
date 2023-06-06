import 'package:chat_app/utils/extractor.dart';
import 'package:chat_app/controllers/reminder.dart';
import 'package:chat_app/controllers/saved_message.dart';

class Respuesta {
  Respuesta();

  getResponse(i1, i2, i3) async {
    //i1 = Intent
    //i2 = entities
    //i3 = message
    print(i1);
    print(i2);
    print(i3);
    var ret2;
    String d = "m";
    SavedMessage saveMessageController = SavedMessage();

    //COMPROBAMOS LA INTECION

    if (i1 == "REMINDER1") {
      d = "w";
      //MIRAMOS SI TIENE ENTIDADES
      if (i2 != "[]") {
        List<String> str = (Extractor(i2).fecha()).toString().split(" ");

        DateTime d = DateTime.parse(str[0]);

        Reminder reminder = Reminder();

        await reminder.createItem(i3, d, 0, 0, "", "");

        ret2 =
            "$i3/${d.toString().split(" ")[0]}/${0}/${0}/${"days"}/${"00:00"}";

        //ESTO ES LO QUE DEVUELVE EL METODO DE CREAR

        //reminder.delete();
      }
    }

    //print(i2.isNotEmpty);

    await saveMessageController.createItem(ret2.toString(), 0, d);
    return ret2.toString();
  }
}
