import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/screens/acceptStoragePermission.dart';
import 'package:jukebox/screens/hostGuestChoiceSelection.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheckingScreen extends StatefulWidget {
  const PermissionCheckingScreen({Key? key}) : super(key: key);

  @override
  State<PermissionCheckingScreen> createState() =>
      _PermissionCheckingScreenState();
}

class _PermissionCheckingScreenState extends State<PermissionCheckingScreen> {

  @override
  void initState() {
    super.initState();
    permissionCheck()
        .then((isAllPermissionAccepted) => {
          if(isAllPermissionAccepted){
            Get.offAll(() => HostGuestChoiceSelectionScreen())
          }else{
          Get.offAll(()=> AcceptStoragePermissionScreen())
          }
        }
    );
  }

  Future<bool> permissionCheck() async {
    await Future.delayed(const Duration(seconds: 2));
    var storageStatus = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;
    return storageStatus.isGranted && cameraStatus.isGranted &&
        locationStatus.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          color: ColorTheme.circularSpinnerColor,),
      ),
    );
  }
}
