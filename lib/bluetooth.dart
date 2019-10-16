import 'package:flutter/material.dart';


class Bluetooth extends StatefulWidget {
  Bluetooth({Key key}) : super(key: key);

  @override
  BluetoothState createState() => BluetoothState();
}

class BluetoothState extends State<Bluetooth> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Bluetooth'),
      ),

      body: Container(
        child: Center(
          child: Text(
            'Bluetooth',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
