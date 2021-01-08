import 'package:agora/produce_stream.dart';
import 'package:agora/view_stream.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.padding), onPressed: () async {
                await _handleCameraAndMic();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ProduceStream(channelName: 'channel'),),);
              }),
              IconButton(icon: Icon(Icons.ac_unit), onPressed: () async {
                await _handleCameraAndMic();
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ViewStream(channelName: 'channel'),),);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    var status = await Permission.camera.request();
    print(status);
    status = await Permission.microphone.request();
    print(status);
  }
}