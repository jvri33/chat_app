import 'package:chat_app/pages/vivy.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'settings_page.dart';
import 'chat_reminders.dart';
import '../controllers/notification_service.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool night;
  HomeScreen(this.night, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    NotiticationService().initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, SettingsPage(widget.night));
              },
              icon: const Icon(Icons.settings))
        ],*/
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
            gradient: widget.night == false
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
            // set the scroll direction to horizontal
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              // add your widgets here
              Column(
                children: [
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
                        onPressed: (() => nextScreen(context, const Chat())),
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
                          width: 200,
                        ),
                      ),
                    ),
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
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 104),
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
                        onPressed: (() => nextScreen(context, const Vivy())),
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
                          width: 200,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
