import 'package:chat_app/main.dart';
import 'package:chat_app/pages/vivy.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

import 'chat_reminders.dart';
import '../controllers/notification_service.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Function seteNight;
  bool night;
  HomeScreen(this.seteNight, this.night, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();

    NotiticationService().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          IconButton(
              onPressed: () {
                widget.seteNight();
              },
              icon: night == true
                  ? const Icon(Icons.dark_mode_outlined)
                  : const Icon(Icons.light_mode_outlined))
        ],
        title: const Text(
          "Chub",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: SizedBox(
          // change your height based on preference

          width: double.infinity,
          child: PageView(
            controller: _pageController,
            // set the scroll direction to horizontal
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              // add your widgets here
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: 65),
                          child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                weight: 50,
                                size: 0,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 80),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 20,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: (() => nextScreen(context, Chat(night))),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,

                              shape: const CircleBorder(),

                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary, // <-- Button color
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiary, // <-- Splash color
                            ),
                            child: Image.asset(
                              'assets/timmy.png',
                              width: 180,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 65),
                        child: IconButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              weight: 50,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            )),
                      )
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("Timmy",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 34))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Tareas y recordatorios",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Gestión del calendario",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Detección de fechas y horas",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)))
                ],
              ),
              // space them using a sized box

              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 65),
                          child: IconButton(
                              onPressed: () {
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                weight: 50,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 80),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 20,
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          child: ElevatedButton(
                            onPressed: (() => nextScreen(
                                context, Vivy(night, widget.seteNight))),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,

                              shape: const CircleBorder(),

                              backgroundColor:
                                  const Color(0xff77f7aa), // <-- Button color
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiary, // <-- Splash color
                            ),
                            child: Image.asset(
                              'assets/vivy.png',
                              width: 180,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 65),
                          child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                weight: 50,
                                size: 0,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                      )
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text("Vivy",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 34))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Escanea códigos QR",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Escanea documentos",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Detección de fechas y horas",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
