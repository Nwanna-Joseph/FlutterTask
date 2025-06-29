import 'package:flutter/material.dart';
import 'package:taskit/presentation/screen/util/textstyle_util.dart';

Widget boldText(String text){
  return Text(text,
  style: const TextStyle(
    fontSize: fontSizeBold,
    fontWeight: fontWeightBold
  ),
  );
}