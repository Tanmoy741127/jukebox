import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:jukebox/helper/fileHelper.dart';

class MusicTransferServer extends GetxController{
  File? file;
  bool fileAttached = false;
  late ServerSocket server;

  @override
  void onReady() {
    super.onReady();
    startServer()
    .then((_) {
      if(kDebugMode) {
        print("Music transfer server is ready to serve !");
      }
    });
  }

  Future<void> startServer()async{
    server = await ServerSocket.bind('0.0.0.0', 8080);
    server.listen((client) async{
      if(!fileAttached || file == null){
        client.write("not-found");
        client.close();
      }else{
        file!.openRead().pipe(client);
      }
    });
  }


  Future<bool> attachFileFromAssets(String path)async{
    try{
      file = await getFileFromAssets(path);
    }catch(_){
      fileAttached = false;
    }
    if(file != null){
      fileAttached = true;
    }
    return fileAttached;
  }

  Future<bool> attachFile(File file)async{
    try{
      if(file != null && (await file.exists())){
        this.file = file;
        fileAttached = true;
      }else{
        fileAttached = false;
      }
    }catch(_){
      fileAttached = false;
    }
    return fileAttached;
  }
}