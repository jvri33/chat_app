import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../pages/vivy.dart';
import '../widgets.dart';

class CameraTest extends StatefulWidget {
  final Function sete;
  final CameraDescription camera;
  Function f;
  CameraTest(this.camera, this.f, this.sete, {super.key});

  @override
  State<CameraTest> createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            await _controller.setFocusMode(FocusMode.locked);
            await _controller.setExposureMode(ExposureMode.locked);
            final image = await _controller.takePicture();
            await _controller.setFocusMode(FocusMode.locked);
            await _controller.setExposureMode(ExposureMode.locked);
            if (!mounted) return;
            dynamic bytes = await image.readAsBytes();

            // ignore: use_build_context_synchronously
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    image: bytes, sete: widget.sete, funcion: widget.f),
              ),
            );
          } catch (e) {}
        },
        child: Icon(
          Icons.camera_alt,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  Function sete;
  final Uint8List image;
  final _controllercc = CropController();
  Function funcion;
  DisplayPictureScreen(
      {super.key,
      required this.image,
      required this.sete,
      required this.funcion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Crop(
            interactive: false,
            fixArea: false,
            aspectRatio: null,
            initialSize: 0.5,
            image: image,
            controller: _controllercc,
            onCropped: (image) async {
              await funcion(image);
              nextScreen(context, Vivy(false, sete));
              //imageTransform(image);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controllercc.crop,
        child: Icon(
          Icons.cut,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

img.Image imageTransform(image) {
  img.Image? image2 = img.decodeImage(image);
  image2 = img.grayscale(image2!);

  int ventana = 24;
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
  print("finalizado");
  return image2;
}
/*
class DisplayCropped extends StatelessWidget {
  final Uint8List image;
  late img.Image thresholded;

  DisplayCropped({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: imageTransform(),
        builder: (BuildContext context, snapshot) {
          if (thresholded.isNotEmpty) {
            return Image.memory(img.encodePng(thresholded));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}*/
