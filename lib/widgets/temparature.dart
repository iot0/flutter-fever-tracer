import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:provider/provider.dart';

class TemparatureWidget extends StatefulWidget {
  @override
  _TemparatureState createState() => _TemparatureState();
}

class _TemparatureState extends State<TemparatureWidget> {
  double _value;
  bool _alert = false;

  showSnackbar(context) {
    FlutterRingtonePlayer.playAlarm();

    final snackBar = SnackBar(
      // the duration of your snack-bar
      duration: Duration(milliseconds: 60000),
      content: Row(
        children: <Widget>[
          // add your preferred icon here
          Icon(
            Icons.info,
            color: Colors.white,
          ),
          // add your preferred text content here
          Text('High Temparature Alert'),
        ],
      ),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );

    final snackbarResult = Scaffold.of(context).showSnackBar(snackBar);

    snackbarResult.closed.then((value) {
      FlutterRingtonePlayer.stop();
      setState(() {
        _alert = false;
      });
    });
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, child) {
        if (provider.alert && !_alert) {
          _alert = true;
          _value = provider.serialData;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackbar(context);
          });
        }

        if (!_alert) _value = provider.serialData;

        return Text(
          _value != null ? "$_value" : "No Data",
          style: new TextStyle(
            fontSize: 20.0,
            color: _alert ? Colors.red : Colors.grey,
          ),
        );
      },
    );
  }
}
