import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration getBackgroundGradient(BuildContext context) {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: <Color>[Colors.purple, Colors.blue],
    ),
  );
}