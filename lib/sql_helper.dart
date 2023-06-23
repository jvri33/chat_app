import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class SQLHelper {
  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      description TEXT,
      date TEXT,
      time TEXT,
      repeat BIT,
      sound BIT,
      days JSON
    );""");
    await database.execute("""CREATE TABLE messages_rem(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      message TEXT,
      user BIT,
      type TEXT
    );""");
  }

  static Future<Database> db() async {
    return openDatabase('dbchat.db', version: 1,
        onCreate: (Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> deleteDatabase(String path) => databaseFactory
      .deleteDatabase("/data/user/0/com.example.chat_app/databases/dbchat.db");

  static Future<String> getPath() => getDatabasesPath();

  static Future<int> createReminder(String? description, String? date,
      int? repeat, int? sound, String? days, String? time) async {
    final db = await SQLHelper.db();

    final data = {
      'description': description,
      'date': date,
      'repeat': repeat,
      'sound': sound,
      'days': days,
      'time': time
    };
    final id = await db.insert('reminders', data,
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<int> createMessage(
      String message, int user, String type) async {
    final db = await SQLHelper.db();
    final data = {'message': message, 'user': user, 'type': type};
    final id = await db.insert('messages_rem', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await SQLHelper.db();

    return db.query('messages_rem', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await SQLHelper.db();
    return db.query('reminders', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getReminder(int id) async {
    final db = await SQLHelper.db();
    return db.query('reminders', where: 'id=?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getRemindersByDay(String m) async {
    //print("Entra en Helper by date");

    final db = await SQLHelper.db();

    return db.query('reminders', where: 'date =?', whereArgs: [m]);
  }

  static Future<int> updateReminder(int id, String? description, String? date,
      int? repeat, int? sound, String? days, String? time) async {
    final db = await SQLHelper.db();

    final data = {
      'description': description,
      'date': date,
      'repeat': repeat,
      'sound': sound,
      'days': days,
      'time': time
    };

    final result =
        await db.update('reminders', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> updateMessageDate(String mes, int id) async {
    final db = await SQLHelper.db();
    //print("updated");
    final data = {'message': mes};
    await db.update('messages_rem', data, where: "id=?", whereArgs: [id]);
  }

  static void updateMessageTime(String time, int id) async {
    final db = await SQLHelper.db();
    final data = {'message': time};
    await db.update('messages_rem', data, where: "id=?", whereArgs: [id]);
  }

  static void updateMessageSound(String s, int id) async {
    final db = await SQLHelper.db();
    final data = {'message': s};
    await db.update('messages_rem', data, where: "id=?", whereArgs: [id]);
  }

  static void updateMessageRepeat(String s, int id) async {
    final db = await SQLHelper.db();
    final data = {'message': s};
    await db.update('messages_rem', data, where: "id=?", whereArgs: [id]);
  }

  static Future<void> updateMessageMess(
      String mess, int id, String type) async {
    final db = await SQLHelper.db();
    final data = {'message': mess, 'type': type};
    await db.update('messages_rem', data, where: "id=?", whereArgs: [id]);
  }

  static Future<void> deleteReminder(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('reminders', where: 'id=?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
