import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jukebox/constants/colors.dart';

// ignore: non_constant_identifier_names
Widget CustomButton(String text, Size size, {Function? onClick, double scale = 1.0}) {
  return SizedBox(
    width: size.width * 0.85 * scale,
    height: 55*scale,
    child: ElevatedButton(
      onPressed: (){
        if(onClick != null) onClick();
      },
      // ignore: sort_child_properties_last
      child: Text(text, style: GoogleFonts.getFont("Poppins", textStyle: TextStyle(
        fontSize: 16.5*scale,
        color: ColorTheme.buttonTextColor,
        letterSpacing: 2.0
      ), fontWeight: FontWeight.w600),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorTheme.buttonBackgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide.none))),
    ),
  );
}
