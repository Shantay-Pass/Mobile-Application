import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  Camera({Key key}) : super(key: key);

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Camera'),
      ),

      body: Container(
        child: Center(
          child: Text(
            'Camera',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
