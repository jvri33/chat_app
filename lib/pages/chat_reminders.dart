import 'dart:convert';
import 'dart:ui';
import 'package:chat_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
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
import 'package:chat_app/widgets/Speech.dart';
import 'package:chat_app/classifiers/intent_classifier.dart';
import 'package:chat_app/classifiers/entity_classifier.dart';

class Chat extends StatefulWidget {
  bool updaterem = false;
  bool night;
  Chat(this.night, {super.key}) {
    print(night);
  }

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late int updateid;
  late String updatemess;

  bool firstTime = false;
  late VideoPlayerController _controllerv;
  late VideoPlayerController _controllerv2;
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
  final PageController _pcontroller = PageController();
  @override
  void initState() {
    super.initState();

    _controllerv = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controllerv.play();
        _controllerv.setLooping(true);
      });

    _controllerv2 = VideoPlayerController.asset('assets/video2.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controllerv2.play();
        _controllerv2.setLooping(true);
      });

    _intentClassifier = IntentClassifier();
    _entityClassifier = Classifier();
    _responseGenerator = Respuesta();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerv.dispose();
    _controllerv2.dispose();
  }

  setText(String t) {
    messageController.text = t;
  }

  void dontSendMessage(id, mess) {
    widget.updaterem = true;
    updateid = id;
    updatemess = mess;
    setState(() {});
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
    getTime();
    var printing = await saveMessageController.getItems();
    savedMessages = printing;
  }

  getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_time') == false &&
        (prefs.getBool('first_time')) != null) {
      firstTime = false;
    } else {
      firstTime = true;
    }
  }

  refresh() {
    setState(() {});
  }

  void sendMessage() async {
    print(widget.updaterem);
    if (widget.updaterem == false) {
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
        decoration: BoxDecoration(
            gradient: night == false
                ? const LinearGradient(
                    colors: [Color(0xff77ddf2), Color(0xff77f7aa)],
                    stops: [0, 1],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft)
                : const LinearGradient(colors: [
                    Color.fromARGB(255, 24, 32, 33),
                    Color.fromARGB(255, 24, 32, 33)
                  ], stops: [
                    0,
                    1
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
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
                    if (savedMessages.asMap().keys.toList().isEmpty) {
                      saveMessageController.createItem(
                          "Hola! Soy Timmy, y estaré encantado de ayudarte a gestionar tu agenda y tu tiempo",
                          0,
                          "m");
                    }
                    if (firstTime == true) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          content: Container(
                            //width: 300,
                            height: MediaQuery.of(context).size.height * 0.6,
                            //color: Theme.of(context).colorScheme.tertiary,
                            child: PageView.builder(
                              controller: _pcontroller,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  _controllerv.play();
                                  _controllerv.setLooping(true);
                                }
                                if (index == 1) {
                                  _controllerv2.play();
                                  _controllerv2.setLooping(true);
                                }
                                return (Column(
                                  //mainAxisAlignment:
                                  //  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: index == 2
                                          ? EdgeInsets.only(bottom: 0)
                                          : EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: AspectRatio(
                                        aspectRatio:
                                            _controllerv.value.aspectRatio,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: index == 1
                                                    ? VideoPlayer(_controllerv2)
                                                    : index == 0
                                                        ? VideoPlayer(
                                                            _controllerv)
                                                        : Container(
                                                            child: Image.asset(
                                                            'assets/timmy.png',
                                                            width: 220,
                                                          )))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        index == 0
                                            ? "Crea recordatorios y tareas escribiendo en el chat."
                                            : index == 1
                                                ? "Gestiona tu calendario con los diferentes widgets."
                                                : "Si tienes cualquier duda pregunta a Timmy y te responderá sin problema!",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: index == 2
                                              ? () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  setState(() {
                                                    firstTime = false;
                                                    prefs.setBool(
                                                        'first_time', false);
                                                  });
                                                }
                                              : () {
                                                  _pcontroller.animateToPage(
                                                      index + 1,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                                },
                                          child: Container(
                                              padding: EdgeInsets.all(12),
                                              child: index == 2
                                                  ? Text(
                                                      "Finalizar",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Siguiente",
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary,
                                                      ),
                                                    ))),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              maxRadius: index == 0 ? 6 : 3,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              maxRadius: index == 1 ? 6 : 3,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              maxRadius: index == 2 ? 6 : 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ));
                              },
                            ),
                          ),
                        ),
                      );
                    } else {
                      _controllerv.pause();
                      _controllerv2.pause();

                      return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            controller: _controller,
                            itemCount:
                                savedMessages.asMap().keys.toList().length,
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
                                    savedMessages[keys[reversedIndex]]
                                        ['message'],
                                    savedMessages[keys[reversedIndex]]['id'],
                                    refresh,
                                    dontSendMessage);
                              } else if (savedMessages[keys[reversedIndex]]
                                      ['type'] ==
                                  'c') {
                                return Calendario(
                                    savedMessages[keys[reversedIndex]]
                                        ['message'],
                                    savedMessages[keys[reversedIndex]]['id'],
                                    refresh);
                              } else if (savedMessages[keys[reversedIndex]]
                                      ['type'] ==
                                  'e') {
                                return EditWidget(
                                    savedMessages[keys[reversedIndex]]
                                        ['message'],
                                    savedMessages[keys[reversedIndex]]['id'],
                                    refresh,
                                    dontSendMessage);
                              } else if (savedMessages[keys[reversedIndex]]
                                      ['type'] ==
                                  'd') {
                                return DeleteWidget(
                                    savedMessages[keys[reversedIndex]]
                                        ['message'],
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
                                return (Week(savedMessages[keys[reversedIndex]]
                                    ['message']));
                              } else {
                                return const Text("Error");
                              }
                            }),
                      );
                    }
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
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: SpeechTT(setText)),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          enabled: !firstTime == true,
                          controller: messageController,
                          onEditingComplete: sendMessage,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                            contentPadding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
                            border: InputBorder.none,
                            hintText: widget.updaterem == false
                                ? 'Escriba un mensaje...'
                                : "Escribe la descripción...",
                          ),
                        ),
                      ),
                      IconButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: widget.updaterem == true
                              ? () async {
                                  SavedMessage s = SavedMessage();

                                  List<String> ss = updatemess.split("/");
                                  if (ss.length == 6) {
                                    ss[0] = messageController.text;
                                  } else {
                                    ss[6] = messageController.text;
                                  }
                                  print(ss);
                                  String messSt = ss.join("/");

                                  print(messSt);
                                  if (ss.length == 6) {
                                    await s.updateMessage(
                                        messSt, updateid, "w");
                                  } else {
                                    await s.updateMessage(
                                        messSt, updateid, "e");
                                  }

                                  messageController.clear();
                                  widget.updaterem = false;

                                  setState(() {});
                                }
                              : sendMessage,
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
