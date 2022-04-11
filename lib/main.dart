import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/Utils/SpUtils.dart';
import 'package:uphold/pages/Gyms/GymDetails.dart';
import 'package:uphold/pages/Login.dart';
import 'package:uphold/pages/Persons/Collections.dart';
import 'package:uphold/pages/Persons/Message.dart';
import 'package:uphold/pages/Persons/Record.dart';
import 'package:uphold/pages/Reservation.dart';
import 'pages/Tabs.dart';
import 'dart:io';
import 'package:flutter/services.dart';



void main() {
  runApp(new MyApp());
  //判断如果是Android版本的话 设置Android状态栏透明沉浸式
  if(Platform.isAndroid){
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  // Future<void> futureUtils;


  @override
  void initState() {
    //futureUtils = SpUtils.getSharedPreferences();
    super.initState();
    // 判断是否登录
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Tabs(),
      routes: {
        '/tabs':(context)=>(Tabs()),
        '/login':(context)=>(Login()),
        '/message':(context)=>(Message()),
        '/record':(context)=>(Record()),
        '/collections':(context)=>(Collections()),
        '/details':(context)=>(GymDetails(title: '',)),
        '/reservartion':(context)=>(Reservartion(title:'',)),

      },
    );
  }
}


