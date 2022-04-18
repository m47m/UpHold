import 'package:flutter/material.dart';

import 'Message.dart';

class MsgDetails extends StatelessWidget {

  MsgBean bean;

  MsgDetails({required this.bean, Key? key}) : super(key: key);

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
        title: new Text('消息详情' ,style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(this.bean.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child:  Text(this.bean.from,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)),
                ),

              ],
            ),
            Text(this.bean.description,style: TextStyle(fontSize: 16)),

            SizedBox(
              height: 100,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Text(this.bean.time,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
