import 'package:chat_app/sql_helper.dart';

class SavedMessage {
  @override
  Future<String> createItem(String s, int n) async {
    await SQLHelper.createMessage(s, n);
    return ("Created succesfully");
  }

  dynamic getItems() async {
    //final data = await SQLHelper.getMessages();
    return ("data");
  }
}
