import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Http extends StatefulWidget {
  Http({Key key}) : super(key: key);

  @override
  _HttpState createState() => _HttpState();
}

class _HttpState extends State<Http> {
  String title = "EV3 Controls";
  String response;
  String baseUri = "http://192.168.0.13:5000";

  String status = "Ready";

  List<String> testProgram = ["mov 4 2", "rot 7 10", "say Hello, world", "pause 5", "mov 3 19"];

  _testApi(String endpoint, [List<String> instructions]) async {

    setState(() {
      status = "Loading data..";
    });

    String indicator;
    try {
      Response response;
      if (instructions != null) {
        response = await http.post("$baseUri/$endpoint", headers: {
          'content-type': 'application/json'
        }, body: json.encode({
          "instructions": instructions
        }));
      }
      else
        response = await http.get("$baseUri/$endpoint");
      var responseJson = jsonDecode(response.body);
      print(responseJson);
      indicator = responseJson['response'] != null ? responseJson['response'] : "Error!";

      if (endpoint == "busy")
      setState(() {
        status = responseJson['status'] ? "Busy" : "Ready";
      });
    } on SocketException catch (e) {
      indicator = "Error!";
      print(e.osError.message);
    }

    setState(() {
      response = indicator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title - $response"),
        centerTitle: true
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("Check EV3 Status - $status"),
            onPressed: () => _testApi("busy"),
            color: Colors.green
          ),
          FlatButton(
            child: Text("Echo"),
            onPressed: () => _testApi("echo"),
            color: Colors.green
          ),
          FlatButton(
            child: Text("Example program"),
            onPressed: () => _testApi("runprogram", testProgram),
            color: Colors.green
          ),
          FlatButton(
            child: Text("Stop program"),
            onPressed: () => _testApi("terminate"),
            color: Colors.green
          )
        ]),
    );
  }
}