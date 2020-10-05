import 'package:flutter/material.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:mr_doctor/widgets/camera.dart';
import 'package:provider/provider.dart';

class TabCamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(builder: (context, provider, child) {
      return Scaffold(body: Camera(provider.alert));
    });
  }
}
