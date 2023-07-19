import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  bool night;
  SettingsPage(this.night, {super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool s = false;
  void initState() {
    s = widget.night;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Modo oscuro",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              Switch(
                  value: s,
                  onChanged: (ss) {
                    setState(() {
                      if (ss == true) {
                      } else {}
                    });
                  })
            ],
          ),
          // change your height based on preference
        ),
      ),
    );
  }
}
