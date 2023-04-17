import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/widgets/saved_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../widgets/message.dart';

import 'package:chat_app/classifiers/intent_classifier.dart';
import 'package:chat_app/classifiers/entity_classifier.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late IntentClassifier _intentClassifier;
  late Classifier _entityClassifier;
  late String prediction = "";
  late String intentPrediction = "";
  List<Message> messages = [];
  SavedMessage saveMessageController = SavedMessage();
  late List<Map<String, dynamic>> savedMessages = [];
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
  }

  Future<void> getMessages() async {
    var printing = await saveMessageController.getItems();
    savedMessages = printing;
  }

  void sendMessage() async {
    messages.clear();
    if (messageController.text.isNotEmpty) {
      intentPrediction = _intentClassifier.classify(messageController.text);
      if (intentPrediction == "") {
        intentPrediction = "No se ha entendido";
        prediction = "";
      } else {
        prediction = "";
      }
      messages.add(Message("", true, messageController.text));
      saveMessageController.createItem(messageController.text, 1);
      if (intentPrediction[intentPrediction.length - 1] == "1") {
        messages.add(Message(intentPrediction, false, messageController.text,
            entities: _entityClassifier.classify(messageController.text)));
        //NO CREAR AQUÍ EL MENSAJE, CREARLO EN EL MESSAGE
      } else {
        messages.add(Message(
          intentPrediction,
          false,
          messageController.text,
        ));
      }

      await saveMessageController.createItem(intentPrediction, 0);

      // Asegura que el ListView se actualice antes de hacer el desplazamiento

    }
    await scrollToEnd();
    setState(() {
      messageController.clear();
    });

    //intent_prediction = "";
  }

  Future<void> scrollToEnd() async {
    await getMessages();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn);
    });
  }

  //FocusNode _messageFocusNode = FocusNode();
  //late String messageInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Agente"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: /*Column(children: [
                Message("message 1", true),
                Message("message 2", false)
              ]),*/

                  FutureBuilder(
                future: getMessages(),
                builder: (context, snapshot) {
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: savedMessages.asMap().keys.toList().length,
                      itemBuilder: (BuildContext context, int index) {
                        var keys = savedMessages.asMap().keys.toList();
                        if (index ==
                            savedMessages.asMap().keys.toList().length - 1) {
                          return Message(messages[1].intentPrediction,
                              messages[1].user, messages[1].message,
                              entities: messages[1].entities);
                        } else {
                          return SavedMessageWidget(
                            savedMessages[keys[index]]['user'],
                            savedMessages[keys[index]]['message'],
                          );
                        }
                      });
                },
              ),
            ),
            /* Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return messages[index];
                  }),
            ),*/
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: messageController,
                        onEditingComplete: sendMessage,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60)),
                            hintText: 'Enter a message',
                            contentPadding:
                                const EdgeInsets.only(left: 25.0, top: 40.0)),
                      ),
                    ),
                    IconButton(
                        onPressed: sendMessage, icon: const Icon(Icons.send))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
