import 'package:flutter/material.dart';

class Util {
   static void snackBar(BuildContext contexts, String textMsg){
    SnackBar snackBar = SnackBar(content: Text(textMsg), elevation: 5,);
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
  }
}