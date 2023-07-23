import 'dart:typed_data';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:image/image.dart' as img;
import 'package:chat_app/controllers/vivy_saved_message.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets.dart';
import 'package:chat_app/widgets/VivyWidgets/cameratest.dart';

// ignore: must_be_immutable
class ScanButton extends StatefulWidget {
  bool cargado = false;
  final camera;
  Function sete;
  String message;
  int id;
  late img.Image im;
  String path = "";

  // ignore: use_key_in_widget_constructors
  ScanButton(this.camera, this.message, this.id, this.sete) {
    List<String> variables = message.split("|");
    if (variables.length == 3) {
      cargado = true;
      path = variables[1];
    }
  }
  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  late List<String> variables = widget.message.split("|");
  late img.Image ii;

  Future<void> recibirFoto(Uint8List i) async {
    VivySavedMessage v = VivySavedMessage();
    await v.updateMessage("Imagen Recibida", widget.id, "pdf");

    widget.message = "Imagen recibida";

    variables = widget.message.split("|");

    Uint8List imageInUnit8List = i;
    // final result = await ImageGallerySaver.saveImage(i);
    //print("try1");
    //print(result);
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/pdf${widget.id}.png').create();
    file.writeAsBytesSync(imageInUnit8List);
  }

  Future<void> onfuture() async {
    if (widget.cargado == false) {
      variables = widget.message.split("|");

      print("entra");
      final tempDir = await getTemporaryDirectory();
      var image =
          await File('${tempDir.path}/pdf${widget.id}.png').readAsBytes();
      widget.im = await compute<Uint8List, img.Image>(imageTransform, image);
      widget.cargado = true;

      Uint8List s = img.encodePng(widget.im);
      //final result = await ImageGallerySaver.saveImage(s);

      File file = await File('${tempDir.path}/pdf${widget.id}.png').create();
      file.writeAsBytesSync(s);

      VivySavedMessage v = VivySavedMessage();

      var url = '${tempDir.path}/pdf${widget.id}.png';

      await v.updateMessage("Imagen procesada|$url|true", widget.id, "pdf");
      variables = widget.message.split("|");
      setState(() {});
    }
  }

  static Future<img.Image> imageTransform(Uint8List li) async {
    img.Image? image2 = img.decodeImage(li);
    image2 = img.grayscale(image2!);

    int ventana = 24;
    double constanteC = 0.35;

    for (var x = 0; x < image2.width; x++) {
      for (var y = 0; y < image2.height; y++) {
        final pixel = image2.getPixel(x, y);
        num ventanaSuma = 0;
        int ventanaContador = 0;

        // Obtener la suma de intensidades de la ventana local
        for (var i = -ventana ~/ 2; i <= ventana ~/ 2; i++) {
          for (var j = -ventana ~/ 2; j <= ventana ~/ 2; j++) {
            if (x + i >= 0 &&
                x + i < image2.width &&
                y + j >= 0 &&
                y + j < image2.height) {
              ventanaSuma += img.getLuminance(image2.getPixel(x + i, y + j));
              ventanaContador++;
            }
          }
        }

        // Calcular el umbral local como el promedio de la ventana
        double umbralLocal = ventanaSuma / ventanaContador * (1 - constanteC);

        // Aplicar el umbral
        if (pixel.luminance <= umbralLocal) {
          image2.setPixel(x, y, img.ColorInt8.rgb(0, 0, 0)); // Black
        } else {
          image2.setPixel(x, y, img.ColorInt8.rgb(255, 255, 255)); // White
        }
      }
    }

    return image2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: widget.message != "Imagen Recibida" &&
                    variables[0] != "Imagen procesada"
                ? TextButton(
                    onPressed: (() => nextScreen(context,
                        CameraTest(widget.camera, recibirFoto, widget.sete))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(variables[0],
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.tertiary)),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(variables[0],
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.tertiary)),
                      ),
                      FutureBuilder(
                          future: onfuture(),
                          builder: (BuildContext builder, snapshot) {
                            print(widget.cargado);
                            if (widget.cargado && widget.path == "") {
                              return Image.memory(img.encodePng(widget.im));
                            } else if (widget.path != "") {
                              return Image.file(File(widget.path));
                            } else {
                              return CircularProgressIndicator();
                            }
                          })
                    ],
                  )),
      ),
    );
  }
}
