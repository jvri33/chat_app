import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/utils/respuestas.dart';
import 'package:chat_app/widgets/TimmyWidgets/calendario.dart';
import 'package:chat_app/widgets/TimmyWidgets/day.dart';
import 'package:chat_app/widgets/TimmyWidgets/delete_widget.dart';
import 'package:chat_app/widgets/TimmyWidgets/edit_widget.dart';
import 'package:chat_app/widgets/TimmyWidgets/popmenu.dart';
import 'package:chat_app/widgets/TimmyWidgets/reminder_widget.dart';
import 'package:chat_app/widgets/saved_message_widget.dart';
import 'package:chat_app/widgets/TimmyWidgets/week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chat_app/classifiers/intent_classifier.dart';
import 'package:chat_app/classifiers/entity_classifier.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int init = 0;
  late Respuesta _responseGenerator;
  late IntentClassifier _intentClassifier;
  late Classifier _entityClassifier;
  late List<String> prediction = [];
  late String intentPrediction = "";
  final ScrollController _controller = ScrollController();
  SavedMessage saveMessageController = SavedMessage();
  late List<Map<String, dynamic>> savedMessages = [];
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
    _responseGenerator = Respuesta();
  }

  calendarButton() {
    messageController.text = "Calendario";
    sendMessage();
  }

  addButton() {
    messageController.text = "Recordatorio";
    sendMessage();
  }

  helpButton() {
    messageController.text = "Ayuda";
    sendMessage();
  }

  Future<void> getMessages() async {
    var printing = await saveMessageController.getItems();
    savedMessages = printing;
  }

  refresh() {
    setState(() {});
  }

  void sendMessage() async {
    if (messageController.text != "") {
      if (messageController.text.isNotEmpty) {
        intentPrediction = _intentClassifier.classify(messageController.text);
        if (intentPrediction == "") {
          intentPrediction = "No se ha entendido";
          //prediction = "";
        }

        saveMessageController.createItem(messageController.text, 1, "m");

        await _responseGenerator.getResponse(
          intentPrediction,
          _entityClassifier.classify(messageController.text),
          messageController.text,
        );
      }
    }

    setState(() {
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [PopMenu(calendarButton, addButton, helpButton)],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              Theme.of(context).colorScheme.secondary, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: [
            CircleAvatar(backgroundColor: Theme.of(context).primaryColor),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Timmy")),
          ],
        ),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff77ddf2), Color(0xff77f7aa)],
          stops: [0, 1],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                        reverse: true,
                        controller: _controller,
                        itemCount: savedMessages.asMap().keys.toList().length,
                        itemBuilder: (BuildContext context, int index) {
                          var keys = savedMessages.asMap().keys.toList();
                          final reversedIndex =
                              savedMessages.asMap().keys.toList().length -
                                  1 -
                                  index;

                          if (savedMessages[keys[reversedIndex]]['type'] ==
                              'm') {
                            return SavedMessageWidget(
                              savedMessages[keys[reversedIndex]]['user'],
                              savedMessages[keys[reversedIndex]]['message'],
                            );
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'w') {
                            return ReminderWidget(
                                savedMessages[keys[reversedIndex]]['message'],
                                savedMessages[keys[reversedIndex]]['id'],
                                refresh);
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'c') {
                            return Calendario(
                                savedMessages[keys[reversedIndex]]['message'],
                                savedMessages[keys[reversedIndex]]['id'],
                                refresh);
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'e') {
                            return EditWidget(
                                savedMessages[keys[reversedIndex]]['message'],
                                savedMessages[keys[reversedIndex]]['id'],
                                refresh);
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'd') {
                            return DeleteWidget(
                                savedMessages[keys[reversedIndex]]['message'],
                                savedMessages[keys[reversedIndex]]['id'],
                                refresh);
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'i') {
                            return DayWidget(
                              savedMessages[keys[reversedIndex]]['message'],
                              savedMessages[keys[reversedIndex]]['id'],
                            );
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'we') {
                            return (Week(
                                savedMessages[keys[reversedIndex]]['message']));
                          } else {
                            return const Text("Error");
                          }
                        });
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8, top: 8),
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -2),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          onEditingComplete: sendMessage,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                            contentPadding: const EdgeInsets.all(20),
                            border: InputBorder.none,
                            hintText: 'Escriba un mensaje...',
                          ),
                        ),
                      ),
                      IconButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: sendMessage,
                          icon: const Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
