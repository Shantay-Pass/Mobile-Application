import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  AudioPlayer audioPlayer = AudioPlayer();

  play() async {
    int result = await audioPlayer.play('https://www.myinstants.com/media/sounds/roblox-death-sound_1.mp3');
    if (result == 1) {
      // success
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => play());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Home'),
      ),

      body: Container(
        child: Center(
          child: Text(
            'Home',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
