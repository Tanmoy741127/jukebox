import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/controllers/musicPlayer.dart';
import 'package:jukebox/screens/musicPlayList.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/musicTransferServer.dart';
import '../controllers/websocketServer.dart';
import '../widgets/connectionStatus.dart';
import '../widgets/nullArtworkCustomWidget.dart';

class MusicPlayerScreen extends StatelessWidget {
  MusicPlayerScreen({Key? key}) : super(key: key);

  final musicTransferServerController = Get.find<MusicTransferServer>();
  final musicPlayerController = Get.find<MusicPlayerController>();
  final webSocketServerController = Get.find<WebSocketServerClient>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebSocketServerClient>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.appBarBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          title: SizedBox(
            width: 100,
            height: 35,
            child: Image.asset("assets/logo.png",),
          ),
          actions: [
            ConnectionStatusWidget(false)
          ],
        ),
        backgroundColor: ColorTheme.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QueryArtworkWidget(
                size: (MediaQuery.of(context).size.width * 0.75).toInt(),
                artworkWidth: MediaQuery.of(context).size.width * 0.75,
                artworkHeight: MediaQuery.of(context).size.width * 0.75,
                id: controller.musicPlayer.currentlyPlayingMusicId.value,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: nullArtworkCustomWidgetLarge(
                    MediaQuery.of(context).size.width * 0.75),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                " ${controller.musicPlayer.currentlyPlayingMusicId.value != -1 ? controller.musicPlayer.currentSong?.title ?? "Unknown" : "No music"} ",
                style: GoogleFonts.getFont("Poppins",
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    )),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              Obx(() => Slider(
                  min: 0,
                  max: controller.musicPlayer.getTotalDuration().toDouble(),
                  value:
                      controller.musicPlayer.getCurrentPosition().toDouble(),
                  onChanged: (val) async {
                    await controller.seekToMusic(val);
                  })),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 1,),
                  GestureDetector(
                    onTap: (){
                      controller.previousMusic();
                    },
                    child: const Icon(
                      Icons.skip_previous_rounded,
                      size: 40,
                    ),
                  ),
                  Obx(()=>GestureDetector(
                    onTap: ()=>controller.musicPlayer.isPlaying.value ? controller.pauseAndBroadcast() : controller.playAndBroadcast(),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ColorTheme.playPauseButtonBackgroundColor,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child:  Icon(
                          controller.musicPlayer.isPlaying.value ? Icons.pause : Icons.play_arrow_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      controller.nextMusic();
                    },
                    child: const Icon(
                      Icons.skip_next_rounded,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>MusicPlayList(), transition: Transition.rightToLeft);
                    },
                    child: const Icon(
                      Icons.queue_music,
                      size: 30,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

Widget _dialogContent() {
  return Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    alignment: Alignment.center,
    padding: EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Scan QR to connect",
          style: GoogleFonts.getFont("Nunito Sans",
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 10,
        ),
        QrImage(
          data: "https://192.168.0.100",
          version: QrVersions.auto,
          size: 200.0,
        ),
        SizedBox(
          height: 10,
        ),
        Text("Running server at 192.168.0.100"),
      ],
    ),
  );
}
