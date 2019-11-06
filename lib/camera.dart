import 'dart:io';
import 'dart:math';
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
    File image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 1000);
    RealImage.Image test = RealImage.decodeImage(image.readAsBytesSync());
    // Don't touch anything above this Andreas!

    // PictureReader PR = new PictureReader(test);
    //RealImage.Image t = RealImage.trim(test, mode: RealImage.TrimMode.topLeftColor);
    RealImage.Image t = _getBasePlate(_trimImage(test));
    //print(t.height);
    //print(t.width);
    //t = _test(t);

    // Don't touch anything below this Andreas!
    image.writeAsBytesSync(RealImage.encodePng(t));

    setState(() {
      _image = image;
    });
  }

  static RealImage.Image _getBasePlate(RealImage.Image image) {
    int pX = -1;
    int qY = -1;
    int qX = -1;
    
    for (int x = 0; x < image.width; x++) {
      Color col = Color(image.getPixel(x, 5));
      col = Color.fromRGBO(col.blue, col.green, col.red, col.opacity);
      
      if(col.red != 255 && col.green != 255 && col.blue != 255) {
        pX = x;
        break;
      }
    }

    for (int y = 0; y < image.height; y++) {
      Color col = Color(image.getPixel(5, y));
      col = Color.fromRGBO(col.blue, col.green, col.red, col.opacity);

      if(col.red != 255 && col.green != 255 && col.blue != 255) {
        qY = y;
        qX = 5;
        break;
      }
    }

    for (int y = 0; y < image.height; y++) {
      Color col = Color(image.getPixel(image.width - 5, y));
      col = Color.fromRGBO(col.blue, col.green, col.red, col.opacity);

      if(col.red != 255 && col.green != 255 && col.blue != 255) {
        if(y < qY) {
          qY = y;
          qX = image.width - 5;
          break;
        }
      }
    }
    
    num a = atan((qY - 5) / (qX - pX)) * 180/pi;

    RealImage.Image rotatedImage = RealImage.copyRotate(image, -a);
    RealImage.Image newImage = RealImage.Image(image.height, image.width, channels: RealImage.Channels.rgba);
    newImage.fill(RealImage.Color.fromRgba(255, 255, 255, 255));

    return RealImage.trim(RealImage.drawImage(newImage, rotatedImage), mode: RealImage.TrimMode.topLeftColor);
  }

  static bool _isShadeOfGray(Color col) {
    int max = col.blue;
    int min = col.blue;

    if(max < col.green)
      max = col.green;
    if(max < col.red)
      max = col.red;
    if(min > col.green)
      min = col.green;
    if(min > col.red)
      min = col.red;

    return (max - min < 60);
  }

  static RealImage.Image _trimImage(RealImage.Image image) {
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        Color col = Color(image.getPixel(x, y));
        col = Color.fromRGBO(col.blue, col.green, col.red, col.opacity);

        if (_isShadeOfGray(col))
          image.setPixelRgba(x, y, 255, 255, 255);
      }
    }
    return RealImage.trim(image, mode: RealImage.TrimMode.topLeftColor);
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

  PictureReader(RealImage.Image _picture){
    picture = _picture;
    start();
  }

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
    print('Commencing Pixel analysis and conversion.\nPicture pixel count:\nx = ' + pictureX.toString() + '\ny = ' + pictureY.toString());
    for( var y = 0 ; y < pictureY; y+=1 ) {
      for( var x = 0 ; x < pictureX; x+=1 ) {
        Color oldPixelColor = Color(picture.getPixel(x, y));
        Color middlemanPixelColor = Color.fromARGB(oldPixelColor.alpha, oldPixelColor.blue, oldPixelColor.green, oldPixelColor.red);
        Color newPixelColor = AnalysePixelColor(middlemanPixelColor);
        picture.setPixelRgba(x, y, newPixelColor.red, newPixelColor.green, newPixelColor.blue, 0xff);
      }
    }

    print('Commencing corner analysis.');
    for( var y = 0 ; y < pictureY; y+=1 ) {
      for( var x = 0 ; x < pictureX; x+=1 ) {
        int frame = 30;
        if ((x > frame && y > frame) && x < pictureX-frame && y < pictureY-frame){
          if (IsUpperLeftCorner(x, y, 10)){
            testDrawSquare(x, y);
          }
        }
      }
    }
  }

  void testDrawSquare(int x, int y){
    print('inside testdrawsquare');
    int size = 5;
    for( var yInc = y-size ; yInc < y+size; yInc+=1 ) {
      for( var xInc = x-size ; xInc < x+size; xInc+=1 ) {

        picture.setPixelRgba(xInc, yInc, 0, 0, 0);

      }
    }
  }

  bool IsUpperLeftCorner(int x, int y, int testMargin){

    print('inside isupperleftcorner');
    Color pixelColor = Color(picture.getPixel(x, y));

    Color pixelSearchColor;
    int errorMargin = 3;

    for( var yInc = y - testMargin ; yInc < y - errorMargin; yInc += 1 ) {
      for( var xInc = x - testMargin ; xInc < x - errorMargin; xInc += 1 ) {
        pixelSearchColor = Color(picture.getPixel(xInc, yInc));
        if (
        !(pixelColor.red == pixelSearchColor.red
        && pixelColor.green == pixelSearchColor.green
        && pixelColor.blue == pixelSearchColor.blue)){
          return false;
        }
      }
    }
    return true;

    Color oldPixelColor = Color(picture.getPixel(x, y));
    Color middlemanPixelColor = Color.fromARGB(oldPixelColor.alpha, oldPixelColor.blue, oldPixelColor.green, oldPixelColor.red);
    Color newPixelColor = AnalysePixelColor(middlemanPixelColor);


  }

  bool IsUpperRightCorner(){
    int differentlyColoredAdjacentPixels;
  }

  bool IsLowerLeftCorner(){
    int differentlyColoredAdjacentPixels;
  }

  bool IsLowerRightCorner(){
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

    double limit = (r+g+b)/3;

    (r >= limit) ? r = r : r = 0;
    (g >= limit) ? g = g : g = 0;
    (b >= limit) ? b = b : b = 0;

    return new Color.fromARGB(255, r, g, b);
  }

  bool isGrayscale(int a, int b, int c){
    //The smaller the ceil variable is, the larger a color variation is necesarry for a color to NOT be deemed a grayscale.
    int ceil = 50;
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