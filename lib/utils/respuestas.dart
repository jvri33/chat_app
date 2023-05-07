import 'package:chat_app/utils/extractor.dart';
import 'package:chat_app/controllers/reminder.dart';
import 'package:chat_app/controllers/saved_message.dart';
class Respuesta {
  
  Respuesta();

  Future<String> getResponse(i1,i2) async {
    SavedMessage saveMessageController = SavedMessage();
    print(i1);
    print(i2);
    //i1 intent
    String ret = "";
    if(i1 == "REMINDER1"){
      ret += "Se ha creado un recordatorio el día x a las x\n";

      //crear un mensaje sin entidades

      //crear un mensaje con entidades

      if(i2 != "[]"){
        //ret+="Se han encontrado entidades";


        List<String> str =
          (Extractor(i2).fecha()).toString().split(" ");

        print("aqui?");
        ret += "${str[0]} ";
        ret += (Extractor(i2).hora().toString());
        Reminder reminder = Reminder();
        int i = await reminder.createItem(ret);

        print("que le pasa a esto $i");
      }



    }
  
    //print(i2.isNotEmpty);


    await saveMessageController.createItem(ret, 0);
    return ret;

    

    
  }

}
