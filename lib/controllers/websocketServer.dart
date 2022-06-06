import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'musicPlayer.dart';
import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as SocketClient;

import 'musicTransferServer.dart';

class WebSocketServerClientSystem extends GetxController{
  late MusicPlayerController musicPlayer;
  late bool isHostMode;
  Server? server;
  SocketClient.Socket? socket;

  // Own ip address
  String ? ipAddress = "";
  String serverIpAddress = "";

  // State
  Timer ? playMusicTimer;
  RxBool isDownloadingMusic = false.obs;
  RxBool isConnectedToSever = false.obs;


  // Constructor
  WebSocketServerClientSystem( this.musicPlayer, this.isHostMode, {String serverIpAddress = ""}){
    this.serverIpAddress = serverIpAddress;
  }

  void onReady(){
    super.onReady();
    init()
    .then((_) => print("Inited websocket server/client"));
  }

  Future<void> init() async {
    if(isHostMode){
      await initWebSocketServer();
    }else{
      await initWebSocketClient();
    }
  }

  Future<void> initWebSocketServer()async{
    server = Server();
    server?.on('connection', (client){
      client.on("command_to_server", (command) async {
        if(command == 'play'){
          if(musicPlayer.isPlaying.value == false) await playAndBroadcast();
        }else if(command == 'pause'){
          if(musicPlayer.isPlaying.value == true) pauseAndBroadcast();
        }else if(command == 'next_music'){
          nextMusic();
        }else if(command == 'previous_music'){
          previousMusic();
        }
      });
    });
    server?.listen(8081).then((value){
      startScheduledTasks();
    });
  }

  Future<void> initWebSocketClient()async{
    socket = SocketClient.io('http://$serverIpAddress:8081', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket?.onConnect((_) {
      print('connect');
    });
    socket?.connect();
    startScheduledTasks();

    socket?.on("status", (data) async {
      await seekToMusicForClient(double.parse(data["position"].toString()));
      // TODO handle synchronization in a better way
      if(data["playing"]){
        await musicPlayer.play();
      }else{
          musicPlayer.pause();
      }
    });
    socket?.on("seek_to_immediate", (data) async {
     await seekToMusicForClient(double.parse(data.toString()));
    });
    socket?.on("song_title", (data){
      musicPlayer.currentSongTitle = data;
      update();
    });
    socket?.on("command", (data) async {
      if(data == 'play'){
       await musicPlayer.play();
      }
      else if(data == 'pause'){
        musicPlayer.pause();
      }else if(data == 'new_music'){
        musicPlayer.pause();
        isDownloadingMusic.value = true;
        await musicPlayer.downloadMusic(serverIpAddress);
        isDownloadingMusic.value = false;
        update();
      }
    });
  }


  Future<void> startScheduledTasks()async{
    // Send music state and current position
    if(isHostMode){
      await musicPlayer.loadSongsPlaylist();
      Timer.periodic(const Duration(seconds: 5), (Timer t) =>{
        server?.emit("status", musicPlayer.getStatusJSON())
      });
    }else{
      Timer.periodic(const Duration(seconds: 5), (timer) {
        isConnectedToSever.value = socket?.connected??false;
      });
    }
  }
  
  Future<void> seekToMusicForClient(double val)async{
      await musicPlayer.setSeekbarPosition(val);
  }

  Future<void> seekToMusic(double val)async{
    if(isHostMode){
      if(musicPlayer.isPlaying()) pauseAndBroadcast();
      await musicPlayer.setSeekbarPosition(val);
      if(playMusicTimer != null) playMusicTimer!.cancel();
      playMusicTimer = Timer(const Duration(milliseconds: 500), ()async {
        server?.emit("seek_to_immediate", musicPlayer.getCurrentPosition());
        await playAndBroadcast();
      });
    }else {
      Get.snackbar("Not allowed", "This function is only available for server");
    }
    // TODO if client just send a request to server
  }

  Future<void> playAndBroadcast()async{
    if(isHostMode){
      server?.emit("command", "play");
      await musicPlayer.play();
    }else{
      socket?.emit("command_to_server", "play");
    }
  }

  void pauseAndBroadcast(){
    if(isHostMode){
      server?.emit("command", "pause");
      musicPlayer.pause();
    }else{
      socket?.emit("command_to_server", "pause");
    }
  }

  // This function specific for server side purpose
  Future<void> setMusicFromPlaylist(int index)async{
    pauseAndBroadcast();
    musicPlayer.setMusicFromPlaylist(index);
    final musicServer = Get.find<MusicTransferServer>();
    musicServer.file = await toFile(musicPlayer.currentSongUri??"");
    musicServer.fileAttached = true;
    server?.emit("song_title", musicPlayer.currentSongTitle);
    server?.emit("command", "new_music");
    update();
    playAndBroadcast();
  }



  Future<void> nextMusic()async{
    if(isHostMode){
      musicPlayer.nextMusic();
      final musicServer = Get.find<MusicTransferServer>();
      musicServer.file = await toFile(musicPlayer.currentSongUri??"");
      musicServer.fileAttached = true;
      server?.emit("song_title", musicPlayer.currentSongTitle);
      server?.emit("command", "new_music");
      update();
    }else{
      socket?.emit("command_to_server", "next_music");
    }
  }

  Future<void> previousMusic()async{
    if(isHostMode){
      musicPlayer.previousMusic();
      final musicServer = Get.find<MusicTransferServer>();
      musicServer.file = await toFile(musicPlayer.currentSongUri??"");
      musicServer.fileAttached = true;
      server?.emit("song_title", musicPlayer.currentSongTitle);
      server?.emit("command", "new_music");
      server?.emit("command", "new_music");
      update();
    }else{
      socket?.emit("command_to_server", "previous_music");
    }
  }



}