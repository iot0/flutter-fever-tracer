import 'package:flutter/material.dart';
import 'package:mr_doctor/pages/tab_camera.dart';
import 'package:mr_doctor/pages/tab_settings.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book)),
              Tab(icon: Icon(Icons.settings))
            ],
          ),
          title: Text('Fever Tracer'),
        ),
        body: TabBarView(
          children: [TabCamera(), TabSettings()],
        ),
      ),
    );
  }
}
