import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jukebox/constants/colors.dart';

Widget IconRoundedBackground(IconData icon, double width, {bool isSmall = false}) {
  return Container(
    width: width,
    height: width,
    decoration: BoxDecoration(
      color: ColorTheme.iconBackgroundColor,
      borderRadius: BorderRadius.circular(100),
    ),
    alignment: Alignment.center,
    child: Icon(icon, color: ColorTheme.iconsColor,size: isSmall ? width-35 : width-60,),
  );
}