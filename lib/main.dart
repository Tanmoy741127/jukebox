import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/screens/permissionCheckingScreen.dart';
import 'package:jukebox/screens/hostGuestChoiceSelection.dart';

void main() {
  runApp(const MyApp());
}

const finalScreen = HostGuestChoiceSelectionScreen();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(255, 255, 255, 1),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Juke Box',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        sliderTheme: const SliderThemeData(
          trackHeight: 6,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
          thumbColor: Colors.redAccent,
          activeTrackColor: ColorTheme.sliderForegroundColor,
          inactiveTrackColor: ColorTheme.sliderBackgroundColor,
        )
      ),
      home: const PermissionCheckingScreen(),
    );
  }
}
