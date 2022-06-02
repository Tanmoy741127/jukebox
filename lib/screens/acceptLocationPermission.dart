import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/icon_rounded_background.dart';

class AcceptLocationPermissionScreen extends StatefulWidget {
  const AcceptLocationPermissionScreen({Key? key}) : super(key: key);

  @override
  State<AcceptLocationPermissionScreen> createState() =>
      _AcceptLocationPermissionScreenState();
}

class _AcceptLocationPermissionScreenState
    extends State<AcceptLocationPermissionScreen> {
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
            IconRoundedBackground(Icons.location_on, 200.0),
            const SizedBox(height: 45,),
            Text(
              "LOCATION",
              style: GoogleFonts.getFont("Poppins",
                  textStyle: const TextStyle(
                      color: ColorTheme.textPrimaryColor, fontSize: 23),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "To be able to connect with other devices, location is required",
              style: GoogleFonts.getFont("Poppins",
                  textStyle: const TextStyle(
                    color: ColorTheme.textSecondaryColor,
                    fontSize: 17,
                  ),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 85,),
            CustomButton("ALLOW", MediaQuery.of(context).size)
          ],
        ),
      )),
    );
  }
}
