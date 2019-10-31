import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as RealImage;

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File _image;

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    RealImage.Image test = RealImage.decodeImage(image.readAsBytesSync());

    for(int i = 0; i < 100; i++) {
      for(int j = 0; j < 100; j++) {
        test.setPixelRgba(i, j, 255, 0, 0);
      }
    }

    image.writeAsBytesSync(RealImage.encodePng(test));

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}