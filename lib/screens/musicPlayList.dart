import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/controllers/musicPlayer.dart';
import 'package:jukebox/controllers/websocketServer.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widgets/nullArtworkCustomWidget.dart';

class MusicPlayList extends StatelessWidget {
   MusicPlayList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return GetX<WebSocketServerClient>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ColorTheme.backgroundColor,
            appBar: AppBar(
              backgroundColor: ColorTheme.backgroundColor,
              title: const Text("Choose music"),
              elevation: 1,
            ),
            body: controller.musicPlayer.isLoadingPlaylist.value ? const Center(child: CircularProgressIndicator(color: ColorTheme.circularSpinnerColor,)) :
                  controller.musicPlayer.songs.isEmpty ? Center(child: Text("Sorry ! no music found", style: GoogleFonts.getFont("Poppins", textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17
                  )),),):
                      SingleChildScrollView(
                        child: Column(
                          children: controller.musicPlayer.songs.map((e) => ListTile(
                            enableFeedback: true,
                            onTap: (){
                              controller.setMusicFromPlaylist(controller.musicPlayer.songs.indexOf(e));
                            },
                            title: Text(e.title, style: GoogleFonts.getFont("Poppins", textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.7
                            )),overflow: TextOverflow.ellipsis,),
                            subtitle: Text(e.artist ?? "No Artist", style: GoogleFonts.getFont("Poppins", textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.1
                            )),overflow: TextOverflow.ellipsis,),
                            trailing: controller.musicPlayer.currentlyPlayingMusicId.value == e.id ? Icon(Icons.graphic_eq) : null,
                            leading: QueryArtworkWidget(
                              artworkWidth: 45,
                              artworkHeight: 45,
                              id: e.id,
                              type: ArtworkType.AUDIO,
                              artworkBorder: BorderRadius.circular(10),
                              nullArtworkWidget: nullArtworkCustomWidget(),
                            ),
                          )).toList()

                        ),
                      )

          ),
        );
      }
    );
  }
}


