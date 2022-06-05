import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/controllers/musicPlayer.dart';
import 'package:jukebox/screens/musicPlayList.dart';
import 'package:lottie/lottie.dart';
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
  final webSocketServerController = Get.find<WebSocketServerClientSystem>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebSocketServerClientSystem>(builder: (controller) {
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
            !controller.isHostMode ? ConnectionStatusWidget(false) :
            GestureDetector(
                onTap: ()=>showModalBottomSheet(
                    context: context,
                    builder: (context)=>_dialogContent(controller.ipAddress ?? "Unknown" ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                ),
                child: ConnectionStatusWidgetForHostMode())
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
               controller.isHostMode ? QueryArtworkWidget(
                size: (MediaQuery.of(context).size.width * 0.75).toInt(),
                artworkWidth: MediaQuery.of(context).size.width * 0.75,
                artworkHeight: MediaQuery.of(context).size.width * 0.75,
                id: controller.musicPlayer.currentlyPlayingMusicId.value,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(10),
                nullArtworkWidget: nullArtworkCustomWidgetLarge(
                    MediaQuery.of(context).size.width * 0.75),
              ) : Obx(()=>Lottie.asset("assets/listening-music.json", animate: controller.musicPlayer.isPlaying.value, height: MediaQuery.of(context).size.width * 0.75)),
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
              Obx(()=>Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 40,),
                  GestureDetector(
                    onTap: (){
                      controller.previousMusic();
                    },
                    child: const Icon(
                      Icons.skip_previous_rounded,
                      size: 40,
                    ),
                  ),
                  GestureDetector(
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
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: controller.isHostMode,
                        child: const Icon(
                          Icons.queue_music,
                          size: 25,
                        ),
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      );
    });
  }
}

Widget _dialogContent(String ip_address) {
  return Container(
    padding:  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Scan QR to connect",
              style: GoogleFonts.getFont("Roboto",
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
              ),
            ),
            GestureDetector(
              onTap: ()=>Get.back(),
              child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ColorTheme.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                  child: const Icon(Icons.close_rounded, size: 25,)
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        QrImage(
          data: ip_address,
          version: QrVersions.auto,
          size: 150.0,
        ),
        const SizedBox(
          height: 10,
        ),
        Text("🔥 Running host at $ip_address"),
      ],
    ),
  );
}
