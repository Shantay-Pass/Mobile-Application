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
    // Don't touch anything above this Andreas!

    PictureReader PR = new PictureReader(test);

    // Don't touch anything below this Andreas!
    image.writeAsBytesSync(RealImage.encodePng(PR.picture));

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


class PictureReader {

  RealImage.Image picture;
  int pictureX;
  int pictureY;
  int plateX;
  int plateY;
  double pixelToMillimeterRatio;

  PictureReader(RealImage.Image _picture){ picture = _picture; start();}

  void start(){
    Initialize();
    PictureAnalysis();
  }

  void Initialize(){
    pictureX = picture.width;
    pictureY = picture.height;
    plateX = 50; //cm TODO: Add correct measurements.
    plateY = 100; //cm TODO: Add correct measurements.
    pixelToMillimeterRatio = ReturnRatioApproximation(pictureX, pictureY, plateX, plateY);
  }

  double ReturnRatioApproximation(int picX, int picY, int plX, int plY){
    double avgXRatio = picX/plX;
    double avgYRatio = picY/plY;
    return (avgXRatio+avgYRatio/2);
  }

  void test(){
    for(int i = 0; i < 100; i++) {
      for(int j = 0; j < 100; j++) {
        picture.setPixelRgba(i, j, 255, 0, 0);
      }
    }
  }

  void PictureAnalysis(){
    print('Commencing picture analysis.\nPicture pixel count:\nx = ' + pictureX.toString() + '\ny = ' + pictureY.toString());
    for( var x = 0 ; x < pictureX; x+=1 ) {
      for( var y = 0 ; y < pictureY; y+=1 ) {
        Color oldPixelColor = Color(picture.getPixel(x, y));
        Color middlemanPixelColor = Color.fromARGB(oldPixelColor.alpha, oldPixelColor.blue, oldPixelColor.green, oldPixelColor.red);
        Color newPixelColor = AnalysePixelColor(middlemanPixelColor);
        picture.setPixelRgba(x, y, newPixelColor.red, newPixelColor.green, newPixelColor.blue, 0xff);
      }
    }
  }

  bool IsCorner(){
    int differentlyColoredAdjacentPixels;
  }

  // documentation for understanding the creator of the image plugins encoding
  // https://github.com/brendan-duncan/image/blob/master/lib/src/image.dart
  // Input is encoded as: #AABBGGRR in HEX
  // FLUTTER uses color format ARGB
  Color AnalysePixelColor(Color input){
    int r = input.red;
    int g = input.green;
    int b = input.blue;

    if (isGrayscale(r,g,b)){
      return new Color.fromARGB(255, 255, 255, 255);
    }

    int limit = 50;

    (r >= limit) ? r = 255 : r = 0;
    (g >= limit) ? g = 255 : g = 0;
    (b >= limit) ? b = 255 : b = 0;

    return new Color.fromARGB(255, r, g, b);
  }

  bool isGrayscale(int a, int b, int c){
    double avg = (a+b+c)/3;
    //The smaller the ceil variable is, the larger a color variation is necesarry for a color to NOT be deemed a grayscale.
    int ceil = 25;
    if (a > b && a > c){
      if (b < c){if (a-b < ceil){return true;}}
      else if (c < b){if (a-c < ceil){return true;}}
    }
    else if (b > a && b > c){
      if (a < c){if (b-a < ceil){return true;}}
      else if (c < a){if (b-c < ceil){return true;}}
    }
    else if (c > b && c > a){
      if (a < b){if (c-a < ceil){return true;}}
      else if (b < a){if (c-b < ceil){return true;}}
    }
    return false;
  }

  String ReturnCode(){
    return '[insert return-code here]';
  }
}

enum LegoBrickColour { Green, LightGreen, Yellow, Red, White, Orange, Black }

class Square {
  int topLeftCorner;
  int topRightCorner;
  int bottomLeftCorner;
  int bottomRightCorner;
  LegoBrickColour color;

  Square (int _topLeftCorner, int _topRightCorner, int _bottomLeftCorner, int _bottomRightCorner, LegoBrickColour _color){
    topLeftCorner = _topLeftCorner;
    topRightCorner = _topRightCorner;
    bottomLeftCorner = _bottomLeftCorner;
    bottomRightCorner = _bottomRightCorner;
    color = _color;
  }
}