import 'package:flutter/material.dart';
import 'package:mr_doctor/pages/tab_camera.dart';
import 'package:mr_doctor/pages/tab_settings.dart';
import 'package:mr_doctor/widgets/temparature.dart';

class AppTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/logo.jpg'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera)),
              Tab(icon: Icon(Icons.settings))
            ],
          ),
          title: Text('Fever Tracer'),
          actions: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: TemparatureWidget(),
          )],
        ),
        body: TabBarView(
          children: [TabCamera(), TabSettings()],
        ),
      ),
    );
  }
}
