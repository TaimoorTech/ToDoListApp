import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Util {
   static void snackBar(BuildContext contexts, String textMsg){
    SnackBar snackBar = SnackBar(content: Text(textMsg), elevation: 5,);
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
  }

   static void displayMessage(String message){
     Fluttertoast.showToast(
         msg: message,
         textColor: Colors.black,
         fontSize: 15,
         timeInSecForIosWeb: 2,
         backgroundColor: Colors.blue,
         gravity: ToastGravity.BOTTOM,
         toastLength: Toast.LENGTH_LONG);
   }
}