import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils{
  static late SharedPreferences preferences ;
  static Future<void> getSharedPreferences() async {
    if(preferences == null){
      preferences = await SharedPreferences.getInstance();
    }else {
      return;
    }
  }
}
