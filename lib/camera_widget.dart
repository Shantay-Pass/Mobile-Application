import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hello/hello.dart';
import 'package:hello/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Duncan;

import 'interpreter.dart';

class Camera extends StatelessWidget {
  void _onCameraButtonPressed() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera, );
    
    if(image == null)
      return;

    List<Brick> bricks = await Hello.getImageData(Duncan.decodeImage(image.readAsBytesSync()));
    
    if (bricks.length == 0)
      return;
    
    Hello.runProgram(Interpreter.getInstructions(bricks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ButtonTheme(
        height: double.infinity,
        minWidth: double.infinity,

        child: FlatButton.icon(
          onPressed: _onCameraButtonPressed,
          icon: Icon(Icons.add_a_photo),
          label: Text('Take Photo'),
        ),
      )
    );
  }
}