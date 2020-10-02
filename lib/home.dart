import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  double _tempThreshold = 99;
  bool _alert = false;
  bool _isDialogOpen = false;

  checkAlertStatus() {
    if (_alert && !_isDialogOpen) {
      showAlertDialog(context);
      setState(() {
        _isDialogOpen = true;
      });
    }
  }

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      print("_transaction.stream:" + line);

      if (!_alert) {
        double temparatureValue = double.tryParse(line);
        setState(() {
          if (temparatureValue >= _tempThreshold) {
            _alert = true;
          }
          _serialData.add(Text(line,
              style: new TextStyle(
                fontSize: 20.0,
                color: _alert ? Colors.red : Colors.green,
              )));
          if (_serialData.length > 1) {
            _serialData.removeAt(0);
          }
        });
      }
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName ?? "null"),
          subtitle: Text(device.manufacturerName ?? "null"),
          trailing: RaisedButton(
            child:
                Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        _alert = false;
        _isDialogOpen = false;
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content:
          Column(children: [Text("Temparature is high (F)"), ..._serialData]),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => checkAlertStatus());

    return Scaffold(
      appBar: AppBar(title: Text('Fever Tracer')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                      _ports.length > 0
                          ? "Available Serial Ports"
                          : "No serial devices available",
                      style: Theme.of(context).textTheme.headline6),
                  ..._ports,
                  Text('Status: $_status\n')
                ],
              ),
            ),
          ),
          Expanded(
              child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              children: [
                ...(_serialData.length > 0
                    ? _serialData
                    : [
                        Text("No data",
                            style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ))
                      ])
              ],
            ),
          ))
        ])),
      ),
    );
  }
}
