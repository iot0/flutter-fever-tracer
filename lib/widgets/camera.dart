import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mr_doctor/widgets/scanner_utils.dart';
import 'dart:math' as math;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final bool takePhoto;

  Camera(this.takePhoto);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _camera;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _isDetecting = false;
  bool _isCapturingPicture = false;
  bool _isPhotoSaved = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(description, ResolutionPreset.high);
    await _camera.initialize();

    setState(() {});
  }

  _onRecognition(recognitions) {
    print("_onRecognition");

    if (_isPhotoSaved || _isCapturingPicture) return;
    // The following lines of code toggle the wakelock based on a bool value.
    bool isPersion = false;
    for (var i = 0; i < recognitions.length; i++) {
      if (recognitions[i]["detectedClass"] == "person" &&
          recognitions[i]["confidenceInClass"] > .5) {
        isPersion = true;
        break;
      }
    }

    // Take photo
    if (widget.takePhoto && isPersion) {
      _camera.stopImageStream().then((value) => _takePicture());
    }
  }

  _takePicture() async {
    print("_takePicture");
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    // try {
    _isCapturingPicture = true;
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
    _isPhotoSaved = true;
    _isCapturingPicture = false;
    // } catch (e) {
    //   // If an error occurs, log the error to the console.
    //   print(e);
    //   _isPhotoSaved = false;
    //   _isCapturingPicture = false;
    // }
  }

  showSnackbar(message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_camera == null || !_camera.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    if (widget.takePhoto) {
      _camera.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;

          ScannerUtils.detect(image).then((recognitions) {
            _onRecognition(recognitions);
          }).whenComplete(() => _isDetecting = false);
        }
      });
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = _camera.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(_camera),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }
}
