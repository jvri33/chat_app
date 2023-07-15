import 'package:chat_app/utils/extractor.dart';
import '../controllers/reminder.dart';
import 'package:chat_app/controllers/vivy_saved_message.dart';

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

    if (i3 == "qr") {
      ret2 = "QR/scan";
      dig = "qr";
    }

    if (i3 == "pdf") {
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
