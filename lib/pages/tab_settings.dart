import 'package:flutter/material.dart';
import 'package:mr_doctor/widgets/device_connect.dart';

class TabSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Column(children: <Widget>[DeviceConnectWidget()])),
      ),
    );
  }
}
