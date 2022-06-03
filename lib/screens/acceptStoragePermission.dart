import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/screens/acceptLocationPermission.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/icon_rounded_background.dart';

class AcceptStoragePermissionScreen extends StatefulWidget {
  const AcceptStoragePermissionScreen({Key? key}) : super(key: key);

  @override
  State<AcceptStoragePermissionScreen> createState() =>
      _AcceptStoragePermissionScreenState();
}

class _AcceptStoragePermissionScreenState
    extends State<AcceptStoragePermissionScreen> {

  Future<void> acceptPermission()async{
    if (await Permission.storage.request().isGranted) {
      Get.offAll(()=>AcceptLocationPermissionScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                IconRoundedBackground(Icons.find_in_page, 200.0),
                const SizedBox(height: 45,),
                Text(
                  "STORAGE",
                  style: GoogleFonts.getFont("Poppins",
                      textStyle: const TextStyle(
                          color: ColorTheme.textPrimaryColor, fontSize: 23),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "The access to storage allows the player to play the songs stored inside",
                  style: GoogleFonts.getFont("Poppins",
                      textStyle: const TextStyle(
                        color: ColorTheme.textSecondaryColor,
                        fontSize: 17,
                      ),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 85,),
                CustomButton("ALLOW", MediaQuery
                    .of(context)
                    .size, onClick:()async{
                  await acceptPermission();
                })
              ],
            ),
          )),
    );
  }
}
