import 'dart:async';

import 'package:get/get.dart';
import 'musicPlayer.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as SocketClient;

class WebSocketServerClient extends GetxController{
  late MusicPlayerController musicPlayer;
  late bool isHostMode;
  Server? server;
  SocketClient.Socket? socket;

  // State
  Timer ? playMusicTimer;


  // Constructor
  WebSocketServerClient(this.musicPlayer, this.isHostMode);

  void onReady(){
    super.onReady();
    init()
    .then((_) => print("Inited websocket server"));
  }

  Future<void> init() async {
    // await musicPlayer.setAudioSourceFromAssets("music.mp3");
    // await musicPlayer.play();
    if(isHostMode){
      await initWebSocketServer();
    }
  }

  Future<void> initWebSocketServer()async{
    // startScheduledTasks();
    server = Server();
    server?.on('connection', (client){
      client.on("msg", (data){
        print(data);
      });
    });
    server?.listen(8081).then((value){
      startScheduledTasks();
    });
  }

  Future<void> startScheduledTasks()async{
    // Send music state and current position
    if(isHostMode){
      await musicPlayer.loadSongsPlaylist();
      Timer.periodic(const Duration(seconds: 5), (Timer t) =>{
        server?.emit("status", musicPlayer.getStatusJSON())
      });
    }
  }


  Future<void> seekToMusic(double val)async{
    if(musicPlayer.isPlaying()) pauseAndBroadcast();
    await musicPlayer.setSeekbarPosition(val);
    if(playMusicTimer != null) playMusicTimer!.cancel();
    playMusicTimer = Timer(const Duration(milliseconds: 500), ()async {
      server?.emit("seek_to", musicPlayer.getCurrentPosition());
      await playAndBroadcast();
    });
  }

  Future<void> playAndBroadcast()async{
    server?.emit("command", "play");
    await musicPlayer.play();
  }

  void pauseAndBroadcast(){
    server?.emit("command", "pause");
    musicPlayer.pause();
  }

  Future<void> setMusicFromPlaylist(int index)async{
    pauseAndBroadcast();
    musicPlayer.setMusicFromPlaylist(index);
    update();
    playAndBroadcast();
  }

  Future<void> nextMusic()async{
    musicPlayer.nextMusic();
    update();
  }

  Future<void> previousMusic()async{
    musicPlayer.previousMusic();
    update();
  }

}