import 'package:flutter/material.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:mr_doctor/widgets/bndbox.dart';
import 'package:mr_doctor/widgets/camera.dart';
import 'package:mr_doctor/widgets/scanner_utils.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class TabCamera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabCameraState();
}

class _TabCameraState extends State<TabCamera> {
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

    return Consumer<DeviceProvider>(builder: (context, provider, child) {
      return Scaffold(
          body: Stack(
        children: [
          Camera(setRecognitions, provider.alert),
          BndBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              ScannerUtils.getModel()),
        ],
      ));
    });
  }
}
