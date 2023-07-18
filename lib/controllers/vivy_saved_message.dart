import 'package:chat_app/sql_helper.dart';

class VivySavedMessage {
  Future<String> createItem(String s, int n, String s2) async {
    await SQLHelper.createMessageVivy(s, n, s2);

    return ("Created succesfully");
  }

  Future<dynamic> getItems() async {
    final data = await SQLHelper.getMessagesVivy();

    return (data);
  }

  Future<void> updateMessage(String mess, id, String type) async {
    await SQLHelper.updateMessageMessVivy(mess, id, type);
  }
}
