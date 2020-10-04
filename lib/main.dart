import 'package:flutter/material.dart';
import 'package:mr_doctor/pages/tabs.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:mr_doctor/widgets/camera_preview_scanner.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => DeviceProvider(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<DeviceProvider>(context, listen: false).listen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fever Tracer",
      // home: AppTabBar(),
      home: CameraPreviewScanner(),
    );
  }
}
