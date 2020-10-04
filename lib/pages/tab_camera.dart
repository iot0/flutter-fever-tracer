import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:mr_doctor/widgets/camera_utils.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TabCamera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabCameraState();
}

class _TabCameraState extends State<TabCamera> with WidgetsBindingObserver {
  CameraController _camera;
  bool _loading = true;
  bool _savingPhoto = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    setState(() {
      _loading = true;
    });
    final CameraDescription description =
        await CameraUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();
    setState(() {
      _loading = false;
    });
  }

  _takePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      _savingPhoto = true;
      final dir = (await getExternalStorageDirectory()).path;

      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        dir,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _camera.takePicture(path);
      showSnackbar("Photo saved");
      _savingPhoto = false;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
      _savingPhoto = false;
    }
  }

  showSnackbar(message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(builder: (context, provider, child) {
      if (provider.alert && !_savingPhoto) {
        _takePicture();
      }
      return Scaffold(
          body: _loading
              ? Center(child: CircularProgressIndicator())
              : CameraPreview(_camera));
    });
  }

  @override
  void dispose() {
    print("tab camera dispose");
    _camera.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }
}
