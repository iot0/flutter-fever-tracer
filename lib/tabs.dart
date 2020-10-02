import 'package:flutter/material.dart';
import 'view.dart';
import 'home.dart';

class AppTabBar extends StatelessWidget {
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
          children: [HomePage(), ViewTab()],
        ),
      ),
    );
  }
}
