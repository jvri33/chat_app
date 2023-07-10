import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class QR extends StatefulWidget {
  const QR({super.key});

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  String? code;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          print("click");
          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
              context: context,
              onCode: (code) {
                if (code != null) {
                  setState(() {
                    this.code = code;
                  });
                }
              });
        },
        child: Text(code ?? "Click me"));
  }
}
