import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayerController extends GetxController{
  late AudioPlayer _player;
  final position = Duration(seconds: 0).obs ;
  Rx<Duration?> duration = Rx<Duration?>(Duration(seconds: 0));
  final isPlaying = false.obs;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final isLoadingPlaylist = false.obs;
  final currentlyPlayingMusicId = (-1).obs;
  int currentlyPlayingMusicIndex = (-1);
  List<SongModel> songs = [];
  SongModel? currentSong;



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

  Future<void> loadSongsPlaylist()async{
    isLoadingPlaylist.value = true;
    songs = await _audioQuery.querySongs();
    isLoadingPlaylist.value = false;
  }

  void setMusicFromPlaylist(index){
    currentSong = songs[index];
    currentlyPlayingMusicId.value = currentSong?.id ?? 0;
    currentlyPlayingMusicIndex = index;
    setAudioSourceFromUri(currentSong?.uri??"");
  }

  bool nextMusic() {
    if(currentlyPlayingMusicIndex+1 > songs.length-1) return false;
    setMusicFromPlaylist(currentlyPlayingMusicIndex+1);
    return true;
  }

  bool previousMusic() {
    if(currentlyPlayingMusicIndex-1 < 0) return false;
    setMusicFromPlaylist(currentlyPlayingMusicIndex-1);
    return true;
  }

}