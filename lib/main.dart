import 'package:animated_splash/animated_splash.dart';
import 'package:flutter/material.dart';
import 'package:mr_doctor/pages/home.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:mr_doctor/widgets/scanner_utils.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ScannerUtils.loadModel();
  return runApp(
    ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<DeviceProvider>(context, listen: false).listen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fever Tracer",
      home: AnimatedSplash(
        imagePath: 'assets/logo.jpg',
        home: HomePage(),
        duration: 3000,
        type: AnimatedSplashType.StaticDuration,
      ),
    );
  }
}
