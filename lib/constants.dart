import 'package:flutter/material.dart';

Color kblue = Color(0xFF4756DF);
Color kwhite = Color(0xFFFFFFFF);
Color kblack = Color(0xFF000000);
Color kbrown300 = Color(0xFF8D6E63);
Color kbrown = Color(0xFF795548);
Color kgrey = Color(0xFFC0C0C0);

class Constants {
  final primaryColor = const Color(0xff00796B);
  final secondaryColor = const Color(0xff80CBC4);
  final tertiaryColor = const Color(0xff205cf1);
  final blackColor = const Color(0xff1a1d26);

  final greyColor = const Color(0xffd9dadb);

  final Shader shader = const LinearGradient(
    colors: <Color>[Color(0xffffffff), Color(0xffB2DFDB)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final Shader secondaryShader = const LinearGradient(
    colors: <Color>[Color(0xff26A69A), Color(0xff009688)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientTeal = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff80CBC4), Color(0xff26A69A)],
      stops: [0.0, 1.0]);
  final linearGradientGreen = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xffB9F6CA), Color(0xff00E676)],
      stops: [0.0, 1.0]);
}