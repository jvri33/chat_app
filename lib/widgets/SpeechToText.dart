import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTT extends StatefulWidget {
  Function setText;
  SpeechTT(this.setText, {super.key});

  @override
  State<SpeechTT> createState() => _SpeechTTState();
}

class _SpeechTTState extends State<SpeechTT> {
  String text = "";
  SpeechToText speechToText = SpeechToText();

  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          width: 50,
          child: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {},
            child: GestureDetector(
              child: const Icon(
                Icons.mic,
                color: Colors.white,
              ),
              onTapDown: (details) async {
                HapticFeedback.heavyImpact();
                if (!isListening) {
                  var available = await speechToText.initialize();

                  if (available) {
                    setState(() {
                      isListening = true;
                      speechToText.listen(
                        pauseFor: Duration(seconds: 3),
                        onResult: (result) {
                          setState(() {
                            text = result.recognizedWords;
                            widget.setText(text);
                          });
                        },
                      );
                    });
                  }
                }
              },
              onTapUp: (details) {
                HapticFeedback.heavyImpact();
                setState(() {
                  isListening = false;
                });
                speechToText.stop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
