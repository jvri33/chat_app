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
                          // ignore: deprecated_member_use
                          await launch(variables[1].toString());
                        },
                        child: Column(
                          children: [
                            Text("He obtenido la siguiente Url en el QR:\n",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(0))),
                                  padding: const EdgeInsets.all(10),
                                  width: 200,
                                  child: Text(variables[1].toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
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
                                  this.code = code;
                                });
                              });
                        },
                        child: Text("Haz click para escanear el código QR",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).colorScheme.tertiary))))),
      ),
    ));
  }
}
