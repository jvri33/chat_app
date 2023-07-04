import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/date.dart';
import 'package:chat_app/widgets/repeticion.dart';
import 'package:chat_app/widgets/sound.dart';
import 'package:chat_app/widgets/time.dart';
import 'package:flutter/material.dart';
import '../controllers/notification_service.dart';
import '../controllers/reminder.dart';

// ignore: must_be_immutable
class ReminderWidget extends StatefulWidget {
  final Function() notifyParent;
  String response = "Se ha creado el siguiente borrador de recordatorio";

  String message;
  final int id;
  bool state = false;
  ReminderWidget(this.message, this.id, this.notifyParent, {super.key}) {
    //print(message);
    if (message == "Se ha creado el recordatorio correctamente") {
      state = true;
    }
  }

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  //Se ha creado?
  late List<String> variables = widget.message.split("/");

  void updateDate(String newDate) {
    setState(() {
      variables[1] = newDate;
    });
  }

  void updateTime(String newTime) {
    setState(() {
      variables[5] = newTime;
    });
  }

  void updateSound(String newSound) {
    setState(() {
      variables[2] = newSound;
    });
  }

  void updateRepeat(String newRepeat) {
    setState(() {
      variables[3] = newRepeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 75.0,
          maxWidth: 320.0,
        ),
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(0)),
            ),
            color: Theme.of(context).primaryColor,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: widget.state == false
                    ? Column(
                        children: [
                          Text(widget.response,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 8, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DateWidget(
                                        date: variables[1],
                                        id: widget.id,
                                        message: widget.message,
                                        onUpdateDate: updateDate,
                                      ),
                                      TimeWidget(
                                        time: variables[5],
                                        id: widget.id,
                                        message: widget.message,
                                        onUpdateTime: updateTime,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 17, top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SoundWidget(
                                          sound: int.parse(variables[2]),
                                          id: widget.id,
                                          message: widget.message,
                                          onUpdateSound: updateSound),
                                      RepeatWidget(
                                        repeat: int.parse(variables[3]),
                                        id: widget.id,
                                        message: widget.message,
                                        onUpdateRepeat: updateRepeat,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(right: 8, top: 8),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 230,
                                      child: Text("Nombre: ${variables[0]}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    )
                                  ]),
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.only(left: 10),
                                      onPressed: () async {
                                        Reminder rem = Reminder();
                                        int id = await rem.createItem(
                                            variables[0],
                                            variables[1],
                                            int.parse(variables[3]),
                                            int.parse(variables[2]),
                                            "days",
                                            variables[5]);

                                        SavedMessage s = SavedMessage();

                                        widget.message =
                                            "Se ha creado el recordatorio correctamente";
                                        await s.updateMessage(
                                            widget.message, widget.id, "w");

                                        NotiticationService().scheduleNotification(
                                            sound: variables[2] == "1",
                                            id: id,
                                            title: "Recordatorio",
                                            body: variables[0],
                                            scheduledNotificationDateTime:
                                                DateTime.parse(
                                                    "${variables[1]} ${variables[5]}"));

                                        setState(() {
                                          widget.state = true;
                                          widget.response =
                                              "Se ha creado el recordatorio correctamente";
                                        });
                                        widget.notifyParent();
                                      },
                                      icon: const Icon(Icons.check),
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                    : Text(widget.message,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)))),
      ),
    );
  }
}
