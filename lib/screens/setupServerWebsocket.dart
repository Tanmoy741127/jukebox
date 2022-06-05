
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/controllers/musicPlayer.dart';
import 'package:jukebox/controllers/musicTransferServer.dart';
import 'package:jukebox/controllers/websocketServer.dart';
import 'package:jukebox/screens/musicPlayerScreen.dart';
import 'package:network_info_plus/network_info_plus.dart';


class SetupServerWebSocket extends StatefulWidget {



  @override
  State<SetupServerWebSocket> createState() => _SetupServerWebSocketState();
}

class _SetupServerWebSocketState extends State<SetupServerWebSocket> {

  @override
  void initState(){
    super.initState();
    // Try to handle this, if 3 second not efficient
    Timer(const Duration(seconds: 3), (){
      runFunction();
    });
  }

  Future<void> runFunction()async{
    final musicTransferServerController = Get.put(MusicTransferServer(), permanent: true);
    final musicPlayerController = Get.put(MusicPlayerController(), permanent: true);
    final webSocketServerController = Get.put(WebSocketServerClientSystem(musicPlayerController, true), permanent: true);
    final info = NetworkInfo();
    webSocketServerController.ipAddress = await info.getWifiIP();
    Get.offAll(()=>MusicPlayerScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: ColorTheme.circularSpinnerColor,),
            const SizedBox(height: 50,),
            Text("Please wait", style: GoogleFonts.getFont("Poppins", textStyle : const TextStyle(fontSize: 16, color: ColorTheme.textPrimaryColor)),),
            const SizedBox(height: 5,),
            Text("Host setup on the way", style: GoogleFonts.getFont("Poppins", textStyle : const TextStyle(fontSize: 14, color: ColorTheme.textSecondaryColor)),)
          ],
        ),
      ),
    );
  }
}
