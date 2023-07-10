import 'package:chat_app/pages/vivy.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'settings_page.dart';
import 'chat_reminders.dart';
import '../controllers/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SettingsPage());
              },
              icon: const Icon(Icons.settings))
        ],
        title: Text(
          "Chub",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff77ddf2), Color(0xff77f7aa)],
                stops: [0, 1],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Container(
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
                      margin: EdgeInsets.only(top: 104),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(width: 20, color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: (() => nextScreen(context, const Chat())),
                        child: Text("Timmy"),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          //side: BorderSide(color: Colors.white, width: 20),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(100),
                          backgroundColor:
                              Color(0xff77f7aa), // <-- Button color
                          foregroundColor: Colors.white, // <-- Splash color
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // space them using a sized box

              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 104),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(width: 20, color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: (() => nextScreen(context, const Vivy())),
                        child: Text("Vivy"),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          //side: BorderSide(color: Colors.white, width: 20),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(100),
                          backgroundColor:
                              Color(0xff77f7aa), // <-- Button color
                          foregroundColor: Colors.white, // <-- Splash color
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ), /*Row(
          children: [
            ElevatedButton(
              onPressed: () {
                nextScreen(context, const Chat());

                /* NotiticationService().scheduleNotification(
                    title: "Prueba de notificación",
                    body: "Aquí iría el título",
                    scheduledNotificationDateTime:
                        DateTime.now().add(const Duration(seconds: 40)));
*/
              },
              child: const Text("Botón"),
            ),
            ElevatedButton(
                onPressed: (() => nextScreen(context, const Vivy())),
                child: const Text("Vivy"))
          ],
        ),*/
      ),
    );
  }
}
