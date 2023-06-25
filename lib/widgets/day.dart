import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../controllers/reminder.dart';
import '../controllers/saved_message.dart';

// ignore: must_be_immutable
class DayWidget extends StatelessWidget {
  String message;
  int id;
  int cantidad = 0;
  List<Map<String, dynamic>> recordatorios = [];
  DayWidget(this.message, this.id, {super.key});

  late List<String> variables = message.split("/");

  Future<String> getReminders() async {
    //print(variables.toString());

    if (variables[0] == "DAY") {
      String date = variables[1];

      if (date != "NULL") {
        Reminder r = Reminder();
        recordatorios = await r.getItemsByDay(date);

        cantidad = recordatorios.length;


      }
    }

    return "finish";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReminders(),
      builder: (context, snapshot) {
        
        if(cantidad == 0){
return Container(
        child: Text("No hay recordatorios."),
      );
        }
        else{
        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: List.generate(
                                                cantidad, (index) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "${index + 1}. ${recordatorios[index]['description']}  ${recordatorios[index]['time']}",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                      ),
                                                     
                                                    ),        if (index + 1 <
                                                      cantidad)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8),
                                                      child: Divider(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        thickness: 1,
                                                      ),
                                                    ),],
                                                  );
                                              }),
      
      
    );}
  });}

}