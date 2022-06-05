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
            const SizedBox(width: 8,),
            Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.5)
                ),
                child: Icon(Icons.circle, color: status ? const Color.fromRGBO(0, 170, 58, 1) : Colors.red,size: 20,)
            )
          ],
        ),
      ),
    ),
  );
}

Widget ConnectionStatusWidgetForHostMode(){
  return Align(
    child: Padding(
      padding: const EdgeInsets.only(right: 9),
      child: Container(
        height: 38,
        width: 120,
        decoration: BoxDecoration(
            // color: const Color.fromRGBO(218, 218, 218, 1),
          color: Colors.black,
            borderRadius: BorderRadius.circular(18)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Connect", style: GoogleFonts.getFont("Poppins", textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              color: Colors.white
            )),),
            const SizedBox(width: 10,),
            const Icon(Icons.qr_code_2, color: Colors.white,size: 20,)
          ],
        ),
      ),
    ),
  );
}