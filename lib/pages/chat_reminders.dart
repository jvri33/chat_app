import 'package:chat_app/controllers/saved_message.dart';
import 'package:chat_app/utils/respuestas.dart';
import 'package:chat_app/widgets/calendario.dart';
import 'package:chat_app/widgets/reminder_widget.dart';
import 'package:chat_app/widgets/saved_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  SavedMessage saveMessageController = SavedMessage();
  late List<Map<String, dynamic>> savedMessages = [];
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
    _responseGenerator = Respuesta();
  }

  Future<void> getMessages() async {
    var printing = await saveMessageController.getItems();
    savedMessages = printing;
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
            messageController.text);
      }
    }

    await jumpToEnd2();
    setState(() {
      messageController.clear();
    });
  }

  Future<void> jumpToEnd() async {
    await getMessages();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 30);
    });
  }

  Future<void> jumpToEnd2() async {
    await getMessages();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        jumpToEnd();
        init++;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        init = 0;
        return true;
      },
      child: Scaffold(
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
                  child: Text("Agente"))
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
                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: savedMessages.asMap().keys.toList().length,
                        itemBuilder: (BuildContext context, int index) {
                          var keys = savedMessages.asMap().keys.toList();

                          if (savedMessages[keys[index]]['type'] == 'm') {
                            return SavedMessageWidget(
                              savedMessages[keys[index]]['user'],
                              savedMessages[keys[index]]['message'],
                            );
                          } else if (savedMessages[keys[index]]['type'] == 'w'){
                            return ReminderWidget(
                              savedMessages[keys[index]]['user'],
                              savedMessages[keys[index]]['message'],
                              savedMessages[keys[index]]['id'],
                            );
                          }else if(savedMessages[keys[index]]['type'] == 'c'){
                            return Calendario();
                          }
                        });
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
                            onTap: () {
                              if (MediaQuery.of(context).viewInsets.bottom ==
                                  0) {
                                if (_scrollController.position.maxScrollExtent -
                                        _scrollController.offset <=
                                    300) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    _scrollController.jumpTo(_scrollController
                                        .position.maxScrollExtent);
                                  });
                                }
                              }
                            },
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
      ),
    );
  }
}
