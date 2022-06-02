import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jukebox/screens/acceptCameraPermission.dart';
import 'package:jukebox/screens/acceptLocationPermission.dart';
import 'package:jukebox/screens/acceptNetworkPermission.dart';
import 'package:jukebox/screens/acceptStoragePermission.dart';
import 'package:jukebox/screens/hostGuestChoiceSelection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 15, 130, 20),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Juke Box',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HostGuestChoiceSelectionScreen(),
    );
  }
}
