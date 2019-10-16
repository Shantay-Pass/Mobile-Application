import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth extends StatefulWidget {
  Bluetooth({Key key}) : super(key: key);

  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _bluetoothOn = true;
  bool _connecting = false;
  List<BluetoothDevice> _detectedDevices = new List();
  List<BluetoothDevice> _connectedDevices = new List();
  List<Widget> _detectedDevicesWidgets = new List();
  StreamSubscription<ScanResult> _btSubscription;

  _BluetoothWidgetState() {
    _flutterBlue.state.listen((state) {
      switch(state) {
        case BluetoothState.on:
          setState(() {
            _bluetoothOn = true;
          });
          break;
        default:
          setState(() {
            _bluetoothOn = false;
          });
      }
    });

    _detectBluethoothDevices();
    Timer.periodic(new Duration(seconds: 30), (timer) {
      _detectBluethoothDevices();
    });
  }

  Future<void> _updateConnectedDevices() async {
    var connectedDevices = await _flutterBlue.connectedDevices;

    setState(() {
      _connectedDevices = connectedDevices;
    });
  }

  void _detectBluethoothDevices() async {
    print("Starting scan..");
    _detectedDevices = new List();

    //await _updateBluetoothStatus();
    _updateConnectedDevices();

    if(!_bluetoothOn)
      return;

    if(_btSubscription != null && _btSubscription.isPaused)
      _btSubscription.resume();
    else
      _btSubscription = _flutterBlue.scan().listen((scanResult) {
        if (scanResult.device.name.isEmpty || _detectedDevices.contains(scanResult.device))
          return;

        print('Found Bluetooth device: (${scanResult.device.name})');

        _detectedDevices.add(scanResult.device);
      });

    Timer(Duration(seconds: 20), () {
      _btSubscription.pause();
      List<Widget> widgets = new List();
      _detectedDevices.forEach((device) {
        String deviceName = device.name;

        widgets.add(new ButtonTheme(
          minWidth: double.infinity,
          child: FlatButton(
            child: Text("$deviceName"),
            onPressed: () => _connectToDevice(device),
            color: Colors.green,
          )
        ));
      });

      setState(() {
        _detectedDevicesWidgets = widgets;
      });

      print("Completed scan..");
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _connecting = true;
    });

    String deviceName = device.name;
    print("Connecting to device: $deviceName");

    device.state.listen((state) {
      print("Connection state: $state");

      switch(state) {
        case BluetoothDeviceState.connecting:
          setState(() {
            _connecting = true;
          });
          break;
        case BluetoothDeviceState.connected:
          setState(() {
            _connecting = false;
          });
          print("Connected to device $deviceName");
          break;
        case BluetoothDeviceState.disconnecting:
          break;
        case BluetoothDeviceState.disconnected:
          setState(() {
            _connecting = false;
          });
          break;
        default:
          setState(() {
            _connecting = false;
          });
      }
    });

    await device.connect(timeout: Duration(seconds: 30), autoConnect: true);      
  }

  void _disconnectBluetooth(BluetoothDevice device) async {
    print("Disconnecting from device..");

    await device.disconnect();
  }

  List<Widget> _buildBody() {
    List<Widget> widgets = new List();
    if(!_bluetoothOn){
      widgets.add(new Text("Bluetooth is disabled"));
      return widgets;
    }

    if(_connectedDevices.length > 0) {
      widgets.add(new Text("Connected devices: " + _connectedDevices.length.toString()));
      _connectedDevices.forEach((device) {
        widgets.add(new ButtonTheme(
          minWidth: double.infinity,
          child: FlatButton(
            child: Text("Disconnect"),
            onPressed: () => _disconnectBluetooth(device),
            color: Colors.green,
          )
        ));
      });
    } else
      widgets.add(new Text("No connected devices"));

    if (_connecting)
      widgets.add(new Text("Connecting.."));

    widgets.add(Expanded(
      child: ListView(
        padding: EdgeInsets.all(8),
        children: _detectedDevicesWidgets
      ),
    ));
    
    return widgets;
  }

  @override
  void dispose() {
    super.dispose();
    _btSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Bluetooth Device"),
        centerTitle: true
      ),
      body: Center(
        child: Column(
          children: _buildBody(),
        ),
      )
    );
  }
}