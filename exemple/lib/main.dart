import 'package:flutter/material.dart';
import 'package:picture_handler/picture_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
            child: AdvancedCameraPreview(
          pictureCallback: (String path) {
            //Todo do something with the path
          },
        )),
      ),
    );
  }
}
