import 'package:chat_app/sql_helper.dart';

class SavedMessage {
  Future<String> createItem(String s, int n) async {
    await SQLHelper.createMessage(s, n);
    return ("Created succesfully");
  }

  dynamic getItems() async {
    final data = await SQLHelper.getMessages();
    //print("type ${data.asMap().runtimeType}");
   // var keys = data.asMap().keys.toList();
   // print("keys: ${keys}");
    //print(data[keys[0]]);
    return (data);
  }
}
