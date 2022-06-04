import 'dart:ffi';

import 'package:flutter/material.dart';

import '../constants/colors.dart';

Widget nullArtworkCustomWidget(){
  return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      clipBehavior:  Clip.antiAlias,
      child: Container(
        width: 45,
        height: 45,
        color: ColorTheme.nullArtworkWidgetIconColor,
        child: const Icon(
          Icons.headphones,
          color: Colors.white,
          size: 30,
        ),
      )
  );
}


Widget nullArtworkCustomWidgetLarge(double size){
  return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      clipBehavior:  Clip.antiAlias,
      child: Container(
        width: size,
        height: size,
        color: ColorTheme.nullArtworkWidgetIconColor,
        child: Icon(
          Icons.album,
          color: Colors.white,
          size: size*0.5,
        ),
      )
  );
}