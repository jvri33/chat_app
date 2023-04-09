class Reminder {
  int id;
  DateTime d;
  String description;
  bool repeat;
  bool sound;
  List days;
  Reminder(
      this.d, this.id, this.repeat, this.description, this.sound, this.days) {
    //crear un recordatorio
  }

  factory Reminder.fromMap(Map<String, dynamic> data) {
    return Reminder(data['id'], data['d'], data['description'], data['repeat'],
        data['sound'], data['days']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "d": d,
        "description": description,
        "repeat": repeat,
        "sound": sound,
        "days": days
      };

  void editReminder() {}

  void deleteReminder() {}

  String getReminder() {
    return "";
  }
}
