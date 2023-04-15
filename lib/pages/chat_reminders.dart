import 'package:chat_app/controllers/saved_message.dart';
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
  late var savedMessages = [];

  @override
  void initState() {
    super.initState();
    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
    getMessages();
  }

  void getMessages() {
    //savedMessages = saveMessageController.getItems();
  }

  void sendMessage() {
    messages.clear();
    if (messageController.text.isNotEmpty) {
      intentPrediction = _intentClassifier.classify(messageController.text);
      print(intentPrediction);
      if (intentPrediction == "") {
        intentPrediction = "No se ha entendido";
        prediction = "";
      } else {
        prediction = "";
      }
      messages.add(Message("", true, messageController.text));
      saveMessageController.createItem(messageController.text, 1);

      Future.delayed(Duration(milliseconds: 0), () {
        setState(() {
          if (intentPrediction[intentPrediction.length - 1] == "1") {
            messages.add(Message(
                //"Se ha creado su tarea compruebe los datos y modifiquelos como quiera: ",
                intentPrediction,
                false,
                messageController.text,
                entities: _entityClassifier.classify(messageController.text)));
          } else {
            messages.add(Message(
              //"Se ha creado su tarea compruebe los datos y modifiquelos como quiera: ",
              intentPrediction,
              false,
              messageController.text,
            ));
          }
          saveMessageController.createItem(intentPrediction, 0);
        });
        messageController.clear();
        // Asegura que el ListView se actualice antes de hacer el desplazamiento
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });
      });
    }

    //intent_prediction = "";
  }

  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

                  ListView.builder(
                      controller: _scrollController,
                      itemCount: savedMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return savedMessages[index];
                      }),
            ),
            Expanded(
              child: /*Column(children: [
                Message("message 1", true),
                Message("message 2", false)
              ]),*/

                  ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return messages[index];
                      }),
            ),
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
