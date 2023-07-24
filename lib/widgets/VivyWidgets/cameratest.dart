import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../pages/vivy.dart';
import '../widgets.dart';

// ignore: must_be_immutable
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
      ResolutionPreset.veryHigh,
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
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.center,
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
            // ignore: empty_catches
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

// ignore: must_be_immutable
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
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Crop(
            baseColor: Colors.black,
            interactive: false,
            fixArea: false,
            aspectRatio: null,
            initialSize: 0.5,
            image: image,
            controller: _controllercc,
            onCropped: (image) async {
              await funcion(image);
              // ignore: use_build_context_synchronously
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
