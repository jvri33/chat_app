import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

class IntentClassifier {
  //assets

  final _modelFile = 'modelo_intents.tflite';
  final _vocabFile = 'vocabulario_intents.json';

  //parametros

  //final int _sentenceLen = 30;
  late Map<String, int> _dict;

  late Interpreter _interpreter;

  IntentClassifier() {
    _loadModel();
    _loadDictionary();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Loaded succesfully!');
  }

  void _loadDictionary() async {
    final vocab = await rootBundle.loadString('assets/$_vocabFile');
    Map<String, int> jsonMap = Map<String, int>.from(jsonDecode(vocab));

    _dict = jsonMap;
    print(_dict);
  }

  String classify(txt) {
    List<String> txtsep = txt.split(" ");

    List<List<double>> input = tokenizar(txt);
    //padding seguro
    print(input);

    List<List<double>> output = [
      [0.0, 0.0, 0.0]
    ];
    _interpreter.run(input, output);

    //{'o': 1, 'time': 2, 'day': 3, 'month': 4, 'menos': 5}
    List<String> labels = ["REMINDER1", "FUNCTION0", "CALENDAR0"];
    String ret = "";
    print(output);
    for (int k = 0; k < output.length; k++) {
      for (int i = 0; i < output[k].length; i++) {
        if (output[k][i] > 0.9) {
          ret = labels[i];
        }
      }
    }
    print("ret: $ret");
    return ret;
  }

  List<List<double>> tokenizar(String text) {
    final tokens = text.split(' ');

    List<String> lowercaseNames =
        tokens.map((name) => name.toLowerCase()).toList();
    var vector = List<double>.filled(17, 0);
    //parametrizar
    for (var i = 0; i < lowercaseNames.length; i++) {
      if (_dict.containsKey(lowercaseNames[i])) {
        var parsed = _dict[lowercaseNames[i]]?.toDouble();

        vector[i] = parsed as double;
      }
    }
    //String s = "${vector[0]} ${vector[1]} ${vector[2]}";

    return [vector];
  }
}
