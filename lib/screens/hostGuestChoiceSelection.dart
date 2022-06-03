import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';
import 'package:jukebox/screens/scanQrScreen.dart';
import 'package:jukebox/screens/setupServerWebsocket.dart';

import '../widgets/custom_button.dart';
import '../widgets/icon_rounded_background.dart';

class HostGuestChoiceSelectionScreen extends StatefulWidget {
  const HostGuestChoiceSelectionScreen({Key? key}) : super(key: key);

  @override
  State<HostGuestChoiceSelectionScreen> createState() =>
      _HostGuestChoiceSelectionScreenState();
}

class _HostGuestChoiceSelectionScreenState
    extends State<HostGuestChoiceSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _generateCard(
                      MediaQuery.of(context).size,
                      Icons.trip_origin,
                      "HOST",
                      "The host plays and controls the music , as well as the guests",
                      "CREATE", onclick: ()=>Get.offAll(()=>SetupServerWebSocket())),
                  const SizedBox(
                    height: 25,
                  ),
                  _generateCard(
                      MediaQuery.of(context).size,
                      Icons.speaker,
                      "GUESTS",
                      "Connect to an existing host to play the music controlled by the host",
                      "JOIN NOW", onclick: ()=>{
                        Get.to(()=>ScanQrScreen())
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _generateCard(Size size, IconData icon, String title, String description,
    String buttonText,
    {Function? onclick}) {
  return Container(
    width: size.width * 0.9,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
    decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(226, 226, 226, 1), width: 3.5),
        borderRadius: BorderRadius.circular(8)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconRoundedBackground(icon, 70.0, isSmall: true),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: GoogleFonts.getFont("Poppins",
              textStyle: const TextStyle(
                  color: ColorTheme.textPrimaryColor, fontSize: 20),
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          description,
          style: GoogleFonts.getFont("Poppins",
              textStyle: const TextStyle(
                color: ColorTheme.textSecondaryColor,
                fontSize: 15,
              ),
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 25,
        ),
        CustomButton(buttonText, size, scale: 0.75, onClick: ()=>onclick!())
      ],
    ),
  );
}
