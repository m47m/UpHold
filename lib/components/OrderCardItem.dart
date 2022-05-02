import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/components/CodeDialog.dart';
import 'package:uphold/pages/Tabs/MyOrder.dart';

class OrderCardItem extends StatelessWidget {
  ///本Item对应的数据模型
  final OrderBean bean;

  final Order temp;

  final BuildContext context;

  String API = "http://api.uphold.tongtu.xyz";

  OrderCardItem({required this.bean,required this.temp,required this.context,Key? key}) : super(key: key);

  _showDialog() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();

    var response = await dio.get(
        API + "/user/appointment/check?id="+this.temp.id.toString(),
        options: Options(headers: {
          "Auth": _token,
        }));

    print(response.toString());
    
    if(response.statusCode == 200){
      var msg = json.decode(response.toString());

      var codeData = msg['data'];

      print(codeData);
      
      showDialog(
          context: context,
          builder: (context) {
            return CodeDialog(CodeData: codeData,);
          });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 180,
      child: InkWell(
        onTap: (){
          this._showDialog();
        },
        onLongPress: (){
          print("changan");
        },
        child: Card(
          color: Colors.white,
          elevation: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${this.bean.period}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),

                    _getOrderStatus(int.parse(this.bean.status))
                  ],
                ),
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
              ),

              Divider(
                height: 1.5,
                thickness: 1.3,
              ),

              Container(
                height: 30,
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Text(
                  "${this.bean.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: Text(
                  "${this.bean.description}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getOrderStatus(int status){
    Widget?  widgetofStatus;
    switch(status){
      case 1:
       widgetofStatus = Text(
         "已完成",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
       );
        break;
      case 0:
        widgetofStatus = Text(
          "待签到",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.lightGreen),
        );
        break;
      case 2:
        widgetofStatus = Text(
          "待签退",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.redAccent),
        );
        break;
    }
    return widgetofStatus;
  }
}
