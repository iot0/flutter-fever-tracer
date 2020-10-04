import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:provider/provider.dart';

class TemparatureWidget extends StatefulWidget {
  @override
  _TemparatureState createState() => _TemparatureState();
}

class _TemparatureState extends State<TemparatureWidget> {
  _onAlert(DeviceProvider provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackbar(provider);
    });
  }

  _showSnackbar(DeviceProvider provider) {
    FlutterRingtonePlayer.playAlarm();

    final snackBar = SnackBar(
      // the duration of your snack-bar
      duration: Duration(milliseconds: 5000),
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
      provider.cancelAlert();
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
        if (provider.alert) {
          _onAlert(provider);
        }

        return Text(
          provider.serialData != null ? "${provider.serialData}" : "",
          style: new TextStyle(
              fontSize: 24.0,
              color: provider.alert ? Colors.red : Colors.white),
        );
      },
    );
  }
}
