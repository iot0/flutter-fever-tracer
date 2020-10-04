import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:mr_doctor/widgets/bndbox.dart';
import 'package:mr_doctor/widgets/camera.dart';
import 'package:mr_doctor/widgets/scanner_utils.dart';
import 'package:mr_doctor/widgets/temparature.dart';
import 'dart:math' as math;

class TabCamera extends StatefulWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Center(
  //           child: Column(children: <Widget>[
  //         Expanded(
  //             child: FittedBox(fit: BoxFit.contain, child: TemparatureWidget()))
  //       ])),
  //     ),
  //   );
  // }
  @override
  _TabCameraState createState() => new _TabCameraState();
}

class _TabCameraState extends State<TabCamera> {
  List<CameraDescription> cameras;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    print("_recognitions");
    print(recognitions);

    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: cameras != null
          ? Center(
              child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 100.0,
                  color: Colors.pink),
            )
          : Stack(
              children: [
                Camera(
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    ScannerUtils.getModel()),
              ],
            ),
    );
  }
}
