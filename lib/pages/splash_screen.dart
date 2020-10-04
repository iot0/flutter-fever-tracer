import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mr_doctor/widgets/scanner_utils.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    ScannerUtils.loadModel().then((value) {
      Timer(
          Duration(seconds: 3 ),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => HomePage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo.jpg'),
      ),
    );
  }
}
