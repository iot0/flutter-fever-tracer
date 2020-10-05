import 'package:flutter/material.dart';
import 'package:mr_doctor/providers/device.dart';
import 'package:provider/provider.dart';

class DeviceConnectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<DeviceProvider>(builder: (context, provider, child) {
        List<Widget> devices = [];
        provider.devices?.forEach((device) {
          devices.add(ListTile(
              leading: Icon(Icons.usb),
              title: Text(device.productName ?? "null"),
              trailing: RaisedButton(
                child: Text(provider.deviceId == device.deviceId
                    ? "Disconnect"
                    : "Connect"),
                onPressed: () {
                  provider.connectTo(
                      provider.deviceId == device.deviceId ? null : device);
                },
              )));
        });
        return Column(children: [
          Text(
              devices.length > 0
                  ? "Available Serial Ports"
                  : "No serial devices available",
              style: Theme.of(context).textTheme.headline6),
          ...devices,
          Text('Status: ${provider.status}\n')
        ]);
      }),
    ));
  }
}
