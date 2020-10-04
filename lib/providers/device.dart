import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:async';

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class DeviceProvider with ChangeNotifier {
  double _threshold = 99;
  UsbPort _port;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;

  String status = "Idle";
  int deviceId;
  double serialData;
  List<UsbDevice> devices;
  bool alert = false;

  void listen() {
    _setDevices();
    UsbSerial.usbEventStream.listen((UsbEvent event) async {
      _setDevices();
    });
  }

  void _setDevices() async {
    devices = await UsbSerial.listDevices();

    if (devices.length == 0 && deviceId != null) {
      connectTo(null);
    }
    notifyListeners();
  }

  void _reset() {
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

    deviceId = null;
    serialData = null;
    status = "Idle";
    alert = false;
  }

  Future<bool> connectTo(device) async {
    // Reset all
    _reset();

    if (device == null) {
      deviceId = null;
      status = "Disconnected";
      notifyListeners();
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      status = "Failed to open port";
      notifyListeners();
      return false;
    }

    deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    status = "Connected";
    _subscription = _transaction.stream.listen((String line) {
      _setData(line);
    });
    notifyListeners();
    return true;
  }

  void _setData(String data) {
    print("_transaction.stream:" + data);
    serialData = double.tryParse(data);
    if (serialData > _threshold)
      alert = true;
    else
      alert = false;

    notifyListeners();
  }
}
