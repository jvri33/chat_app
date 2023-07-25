import 'package:chat_app/controllers/vivy_saved_message.dart';

import '../controllers/reminder.dart';

class RespuestaVivy {
  RespuestaVivy();

  getResponse(i1, i2, i3) async {
    //i1 = Intent
    //i2 = entities
    //i3 = message

    Reminder delete = Reminder();

    //delete.deleteall();

    String ret2 = "";
    String dig = "m";
    VivySavedMessage saveMessageController = VivySavedMessage();
    print(i1);
    if (i1 == "QR00") {
      ret2 = "QR/scan";
      dig = "qr";
    }

    if (i1 == "PDF00") {
      ret2 = "pdf";
      dig = "pdf";
    }

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
