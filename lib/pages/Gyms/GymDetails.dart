import 'package:flutter/material.dart';

class GymDetails extends StatelessWidget {
   String title = " ";
   GymDetails({Key? key,required this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,  //清除title左右padding，默认情况下会有一定的padding距离
          toolbarHeight: 75, //将高度定到44，设计稿的高度。为了方便适配，
          //推荐使用插件flutter_screenutil做屏幕的适配工作
          backgroundColor: Colors.white,
          elevation: 1,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          centerTitle: true,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          title: new Text(this.title ,style: TextStyle(color: Colors.black),)
      ),
      body: Container(),
    );
  }
}