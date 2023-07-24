import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/foundation.dart';

// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;
import 'package:chat_app/controllers/vivy_saved_message.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import '../widgets.dart';
import 'package:chat_app/widgets/VivyWidgets/cameratest.dart';

// ignore: must_be_immutable
class ScanButton extends StatefulWidget {
  bool cargado = false;
  // ignore: prefer_typing_uninitialized_variables
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
    await v.updateMessage("Estoy procesando tu imagen", widget.id, "pdf");

    widget.message = "Estoy procesando tu imagen";

    variables = widget.message.split("|");

    Uint8List imageInUnit8List = i;
    // final result = await ImageGallerySaver.saveImage(i);

    File file =
        await File('/storage/emulated/0/Download/pdf${widget.id}.png').create();
    file.writeAsBytesSync(imageInUnit8List);
  }

  Future<void> onfuture() async {
    if (widget.cargado == false) {
      variables = widget.message.split("|");

      var image = await File('/storage/emulated/0/Download/pdf${widget.id}.png')
          .readAsBytes();
      widget.im = await compute<Uint8List, img.Image>(imageTransform, image);
      widget.cargado = true;

      Uint8List s = img.encodePng(widget.im);
      //final result = await ImageGallerySaver.saveImage(s);

      File file = await File('/storage/emulated/0/Download/pdf${widget.id}.png')
          .create();
      file.writeAsBytesSync(s);

      VivySavedMessage v = VivySavedMessage();

      widget.path = '/storage/emulated/0/Download/pdf${widget.id}.png';
      widget.message = "Imagen procesada";
      await v.updateMessage(
          "Imagen procesada|${widget.path}|true", widget.id, "pdf");
      variables = widget.message.split("|");
      setState(() {});
    }
  }

  static Future<img.Image> imageTransform(Uint8List li) async {
    img.Image? image2 = img.decodeImage(li);
    image2 = img.grayscale(image2!);

    int ventana = 16;
    double constanteC = 0.25;

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
            child: widget.message != "Estoy procesando tu imagen" &&
                    variables[0] != "Imagen procesada"
                ? TextButton(
                    onPressed: (() => nextScreen(context,
                        CameraTest(widget.camera, recibirFoto, widget.sete))),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text("Pulsa para escanear una imagen",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
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
                            if (widget.cargado && widget.path != "") {
                              return Container(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, bottom: 12),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(0)),
                                      child: GestureDetector(
                                          onTap: () {
                                            showGeneralDialog(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return Container();
                                              },
                                              context: context,
                                              transitionBuilder:
                                                  (BuildContext context, a1, a2,
                                                      w) {
                                                final curvedAnimation =
                                                    CurvedAnimation(
                                                        parent: a1,
                                                        curve: Curves
                                                            .fastOutSlowIn); // Ajusta la curva de animación aquí
                                                return BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 2, sigmaY: 2),
                                                  child: ScaleTransition(
                                                    scale: Tween<double>(
                                                            begin: 0.5,
                                                            end: 1.0)
                                                        .animate(
                                                            curvedAnimation),
                                                    child: AlertDialog(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(16.0),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        'Guardar PDF',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      content: Image.file(
                                                          File(widget.path)),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                              'Guardar PDF',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      16)),
                                                          onPressed: () async {
                                                            await Permission
                                                                .manageExternalStorage
                                                                .request();
                                                            final pdf =
                                                                pw.Document();
                                                            final image =
                                                                pw.MemoryImage(
                                                              File(widget.path)
                                                                  .readAsBytesSync(),
                                                            );

                                                            pdf.addPage(pw.Page(
                                                                build: (pw
                                                                        .Context
                                                                    context) {
                                                              return pw
                                                                  .FullPage(
                                                                ignoreMargins:
                                                                    true,
                                                                child: pw.Image(
                                                                    image),
                                                              ); // Center
                                                            }));

                                                            File file = File(
                                                                '/storage/emulated/0/Download/example.pdf');
                                                            await file
                                                                .writeAsBytes(
                                                                    await pdf
                                                                        .save());

                                                            // ignore: use_build_context_synchronously
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Se ha guardado el pdf en descargas",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'Cancelar',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      16)),
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child:
                                              Image.file(File(widget.path)))));
                            } else {
                              return Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              );
                            }
                          })
                    ],
                  )),
      ),
    );
  }
}
