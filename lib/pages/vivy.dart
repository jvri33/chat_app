import 'package:chat_app/controllers/vivy_saved_message.dart';
import 'package:chat_app/utils/respuestas_vivy.dart';
import 'package:chat_app/widgets/SpeechToText.dart';
import 'package:chat_app/widgets/VivyWidgets/qr.dart';

import 'package:chat_app/widgets/saved_message_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chat_app/classifiers/intent_classifier.dart';
import 'package:chat_app/classifiers/entity_classifier.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Vivy extends StatefulWidget {
  const Vivy({super.key});

  @override
  State<Vivy> createState() => _VivyState();
}

class _VivyState extends State<Vivy> {
  int init = 0;
  late RespuestaVivy _responseGenerator;
  late IntentClassifier _intentClassifier;
  late Classifier _entityClassifier;
  late List<String> prediction = [];
  late String intentPrediction = "";
  final ScrollController _controller = ScrollController();
  VivySavedMessage saveMessageController = VivySavedMessage();
  late List<Map<String, dynamic>> savedMessages = [];
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
    _responseGenerator = RespuestaVivy();
  }

  setText(String t) {
    messageController.text = t;
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
                child: Text("Vivy")),
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
                              'qr') {
                            return QrWidget(
                                savedMessages[keys[reversedIndex]]['message'],
                                savedMessages[keys[reversedIndex]]['id']);
                          } else if (savedMessages[keys[reversedIndex]]
                                  ['type'] ==
                              'tt') {
                            return Text("tt");
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
                      Expanded(child: SpeechTT(setText)),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: messageController,
                          onEditingComplete: sendMessage,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                            contentPadding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
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
