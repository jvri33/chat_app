import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  //assets

  final _modelFile = 'modelo_ventanas.tflite';
  final _vocabFile = 'vocabulario.json';

  //parametros

  //final int _sentenceLen = 30;
  late Map<String, int> _dict;

  late Interpreter _interpreter;

  Classifier() {
    _loadModel();
    _loadDictionary();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelFile);
    //print('Loaded succesfully!');
  }

  void _loadDictionary() async {
    final vocab = await rootBundle.loadString('assets/$_vocabFile');
    Map<String, int> jsonMap = Map<String, int>.from(jsonDecode(vocab));

    _dict = jsonMap;
    //print(_dict);
  }

  List classify(txt) {
    List<String> txtsep = txt.split(" ");

    List<List<double>> input = tokenizar(txt);

    List<List<double>> preds = [];

    for (int i = 0; i < input[0].length; i++) {
      List<double> vec = [];
      if (i - 1 < 0) {
        vec.add(1.0);
      } else {
        vec.add(input[0][i - 1]);
      }

      vec.add(input[0][i]);

      if (i + 1 > input[0].length - 1) {
        vec.add(1.0);
      } else {
        vec.add(input[0][i + 1]);
      }
      preds.add(vec);
    }

    List<List<double>> resultados = [];

    for (int j = 0; j < preds.length; j++) {
      List<List<double>> output = [
        [0.0, 0.0, 0.0, 0.0, 0.0]
      ];

      _interpreter.run(preds[j], output);

      resultados.add(output[0]);
    }
    //{'o': 1, 'time': 2, 'day': 3, 'month': 4, 'menos': 5}
    List<String> labels = ["O", "TIME", "DAY", "MONTH", "MENOS"];

    List ret = [];

    for (int j = 0; j < resultados.length; j++) {
      for (int k = 0; k < resultados[j].length; k++) {
        if (resultados[j][k] > 0.98) {
          if (labels[k] != "O") {
            ret.add([txtsep[j], j, labels[k]]);
          }
        }
      }
    }

    return ret;
  }

  List<List<double>> tokenizar(String text) {
    final tokens = text.split(' ');

    List<String> lowercaseNames =
        tokens.map((name) => name.toLowerCase()).toList();
    var vector = List<double>.filled(lowercaseNames.length, 0);

    for (var i = 0; i < lowercaseNames.length; i++) {
      if (_dict.containsKey(lowercaseNames[i])) {
        var parsed = _dict[lowercaseNames[i]]?.toDouble();

        vector[i] = parsed as double;
      }
    }

    for (var i = 0; i < vector.length; i++) {
      if (vector[i] == 0) {
        vector[i] = 2;
      }
    }

    return [vector];
  }
}
