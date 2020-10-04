// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:mr_doctor/core/constants.dart';
import 'package:tflite/tflite.dart';

class ScannerUtils {
  ScannerUtils._();

  static String _model = ssd;

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static List<Uint8List> _imageToByteListUint8(CameraImage img) {
    return img.planes.map((plane) {
      return plane.bytes;
    }).toList();
  }

  static String getModel() {
    return _model;
  }

  static Future<void> loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/tflite/yolov2_tiny.tflite",
          labels: "assets/tflite/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/tflite/ssd_mobilenet.tflite",
          labels: "assets/tflite/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  static detect(CameraImage image) async {
    if (image == null) return;

    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions;
    if (_model == mobilenet) {
      recognitions = _mobileNet(image);
    } else if (_model == posenet) {
      recognitions = _poseNet(image);
    } else if (_model == yolo) {
      recognitions = _yolov2Tiny(image);
    } else if (_model == ssd) {
      recognitions = _ssdMobileNet(image);
    }
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Detection took ${endTime - startTime}");

    return recognitions;
  }

  static _yolov2Tiny(CameraImage image) async {
    return await Tflite.detectObjectOnFrame(
      bytesList: _imageToByteListUint8(image),
      model: "YOLO",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 0,
      imageStd: 255.0,
      numResultsPerClass: 1,
      threshold: 0.2,
    );
  }

  static _ssdMobileNet(CameraImage image) async {
    return await Tflite.detectObjectOnFrame(
      bytesList: _imageToByteListUint8(image),
      model: "SSDMobileNet",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );
  }

  static _mobileNet(CameraImage image) async {
    return await Tflite.runModelOnFrame(
      bytesList: _imageToByteListUint8(image),
      imageHeight: image.height,
      imageWidth: image.width,
      numResults: 2,
    );
  }

  static _poseNet(CameraImage image) async {
    return await Tflite.runPoseNetOnFrame(
      bytesList: _imageToByteListUint8(image),
      imageHeight: image.height,
      imageWidth: image.width,
      numResults: 2,
    );
  }
}
