import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/controllers/musicPlayer.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/musicTransferServer.dart';
import '../controllers/websocketServer.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen({Key? key}) : super(key: key);

  final musicTransferServerController = Get.find<MusicTransferServer>();
  final musicPlayerController = Get.find<MusicPlayerController>();
  final webSocketServerController = Get.find<WebSocketServerClient>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetX<WebSocketServerClient>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: ColorTheme.backgroundColor,
            body: Column(
              children: [
                Text(controller.musicPlayer.getCurrentPosition().toString()),
                Text(controller.musicPlayer.getTotalDuration().toString()),
                Text(controller.musicPlayer.isPlaying.value.toString()),
                Slider(
                    min: 0,
                    max: controller.musicPlayer.getTotalDuration().toDouble(),
                    value: controller.musicPlayer.getCurrentPosition().toDouble(),
                    onChanged: (val)async{await controller.seekToMusic(val);  }),
                TextButton(onPressed: ()async{
                  if(controller.musicPlayer.isPlaying.value){
                    controller.pauseAndBroadcast();
                  }else{
                    await controller.playAndBroadcast();
                  }
                }, child: Text(controller.musicPlayer.isPlaying.value &&  (controller.musicPlayer.getCurrentPosition() < controller.musicPlayer.getTotalDuration()) ? "Pause" : "Play")),
                TextButton(onPressed: (){
                  showDialog(context: context, builder: (context){
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
                          child: _dialogContent(),
                        )
                  );

                });
                }, child: Text("Just click me"))
              ],
            ),
          );
        }
      ),
    );
  }
}

Widget _dialogContent() {
  return Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16)
    ),
    alignment: Alignment.center,
    padding: EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Scan QR to connect", style: GoogleFonts.getFont("Nunito Sans", textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        )),),
        SizedBox(height: 10,),
        QrImage(
          data: "https://192.168.0.100",
          version: QrVersions.auto,
          size: 200.0,
        ),
        SizedBox(height: 10,),
        Text("Running server at 192.168.0.100"),
      ],
    ),
  );
}