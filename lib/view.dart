import 'package:flutter/material.dart';

class ViewTab extends StatefulWidget {
  @override
  _ViewTabState createState() => _ViewTabState();
}

class _ViewTabState extends State<ViewTab> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: Text('No Datas')),
    );
  }
}
