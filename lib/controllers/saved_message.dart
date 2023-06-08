import 'package:chat_app/sql_helper.dart';

class SavedMessage {
  Future<String> createItem(String s, int n, String s2) async {
    await SQLHelper.createMessage(s, n, s2);
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

  void updateMessage(String mes, int id) async {
    print("updating");
    SQLHelper.updateMessage(mes, id);
  }
}
