import 'package:chat_app/utils/extractor.dart';
import 'package:chat_app/controllers/reminder.dart';
import 'package:chat_app/controllers/saved_message.dart';

class Respuesta {
  Respuesta();

  Future<String> getResponse(i1, i2, i3) async {
    var ret2;
    SavedMessage saveMessageController = SavedMessage();

    //i1 intentString ret = "";
    if (i1 == "REMINDER1") {
      if (i2 != "[]") {
        //ret+="Se han encontrado entidades";

        List<String> str = (Extractor(i2).fecha()).toString().split(" ");
        print(str.toString());

        DateTime d = DateTime.parse(str[0]);

        print(d);

        //print("aqui?");
        //ret += "${str[0]} ";
        //ret += (Extractor(i2).hora().toString());
        Reminder reminder = Reminder();
        int i = await reminder.createItem(i3, d);

        ret2 = await reminder.getReminder(i);
        print(ret2);
        //print("que le pasa a esto $i");
      }
    }

    //print(i2.isNotEmpty);

    await saveMessageController.createItem(ret2.toString(), 0);
    return ret2.toString();
  }
}
