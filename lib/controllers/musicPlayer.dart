import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerController extends GetxController{
  late AudioPlayer _player;
  final position = Duration(seconds: 0).obs ;
  Rx<Duration?> duration = Rx<Duration?>(Duration(seconds: 0));
  final isPlaying = false.obs;

  MusicPlayerController(){
    _player = AudioPlayer();
    position.bindStream(_player.positionStream);
    duration.bindStream(_player.durationStream);
    isPlaying.bindStream(_player.playingStream);
  }

  Future<bool> setAudioSourceFromUri(String uri)async{
    try{
      await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      return true;
    }catch(_){
      return false;
    }
  }

  Future<bool> setAudioSourceFromFile(String filepath)async{
    try{
      _player.setFilePath(filepath);
      return true;
    }catch(_){
      return false;
    }
  }

  Future<bool> setAudioSourceFromAssets(String filepathInAssetsFolder)async{
    try{
      _player.setAsset("assets/$filepathInAssetsFolder");
      return true;
    }catch(_){
      return false;
    }
  }

  Future<void> play()async{
    await _player.play();
  }

  void pause(){
    _player.pause();
  }

  int getCurrentPosition(){
    return position.value.inMilliseconds;
  }

  int getTotalDuration(){
    int val  = duration.value?.inMilliseconds??0;
    return getCurrentPosition() > val ? getCurrentPosition() : val;
  }

  Future<void> setSeekbarPosition(double val) async {
    await _player.seek(Duration(milliseconds: val.toInt()));
  }

  Map<String, dynamic> getStatusJSON(){
    Map<String, dynamic> a  = {};
    a["state"] = _player.playerState.processingState.name.toString();
    a["playing"] = isPlaying();
    a["position"] = getCurrentPosition();
    a["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    return a;
  }


}