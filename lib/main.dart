import 'package:flutter/material.dart';
import 'package:mr_doctor/pages/tabs.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: AppTabBar(),
    );
  }
}
