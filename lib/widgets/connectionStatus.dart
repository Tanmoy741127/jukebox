import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget ConnectionStatusWidget(bool status){
  return Align(
    child: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 38,
        width: 150,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(218, 218, 218, 1),
          borderRadius: BorderRadius.circular(18)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(status ? "Connected" : "Disconnected", style: GoogleFonts.getFont("Poppins", textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12
            )),),
            const SizedBox(width: 10,),
            Icon(Icons.circle, color: status ? const Color.fromRGBO(0, 170, 58, 1) : Colors.red,)
          ],
        ),
      ),
    ),
  );
}