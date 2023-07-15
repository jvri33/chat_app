import 'package:chat_app/controllers/vivy_saved_message.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class QrWidget extends StatefulWidget {
  String message;
  int id;
  QrWidget(this.message, this.id, {super.key});

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  late int idx = widget.message.indexOf("/");
  //late List<String> variables = widget.message.split("/");

  String? code;

  late List variables = [
    widget.message.substring(0, idx).trim(),
    widget.message.substring(idx + 1).trim()
  ];

  /*if(variables[1] != "scan"){
    code = variables[1];
  }*/

  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(200))),
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 75.0,
          maxWidth: 300.0,
        ),
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(0)),
            ),
            color: Theme.of(context).primaryColor,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: variables[1] != "scan"
                    ? GestureDetector(
                        onTap: () async {
                          await launch(variables[1].toString());
                        },
                        child: Column(
                          children: [
                            const Text(
                                "He obtenido la siguiente Url en el QR:\n",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(variables[1].toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                                const Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ),
                      ) /*Text(variables[1].toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white))*/
                    : TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        onPressed: () {
                          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                              context: context,
                              onCode: (code) async {
                                VivySavedMessage v = VivySavedMessage();

                                await v.updateMessage(
                                    "qr/$code", widget.id, "qr");
                                variables[1] = code!;

                                setState(() {
                                  print("state");
                                  this.code = code;
                                });
                              });
                        },
                        child: const Text("Haz click para escanear el código",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white))))),
      ),
    ));
  }
}
