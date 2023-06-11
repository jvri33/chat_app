import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../controllers/reminder.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Calendario extends StatelessWidget {
  const Calendario({super.key});


  Future<String> getReminders() async {
    Reminder r = Reminder();
    String ret = await r.getItems();

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getReminders(), builder: (BuildContext context, AsyncSnapshot<String> snapshot) { 
      print(snapshot.connectionState);
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return const Text('Error');
        } else if (snapshot.hasData) {
          return Text(snapshot.data);
        } else {
          return const Text('Empty data');
        }
      } else {
        return Text('State: ${snapshot.connectionState}');
      }});
    
    
  }
}