import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/components/CodeDialog.dart';
import 'package:uphold/pages/Tabs/MyOrder.dart';


class OrderItem extends StatefulWidget {

  final OrderBean bean;

  final Order temp;

  final BuildContext context;

   OrderItem({required this.bean,required this.temp,required this.context,Key? key}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState(this.bean,this.temp,this.context);
}

class _OrderItemState extends State<OrderItem> {

  final OrderBean bean;

  final Order temp;

  final BuildContext context;

  _OrderItemState( this.bean, this.temp, this.context){}

  String API = "http://120.53.102.205";

  _showDialog() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();

    var response = await dio.get(
        API + "/user/appointment/check?id="+this.temp.id.toString(),
        options: Options(headers: {
          "Auth": _token,
        }));

    //print(this.temp.id.toString());

    print(this.temp.id.toString()+"    "+response.toString());

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

  _cancel() async{
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();

    var response = await dio.delete(
        API + "/user/appointment?id="+this.temp.id.toString(),
        options: Options(headers: {
          "Auth": _token,
        }));

    if(response.statusCode == 200){
      print(this.temp.id.toString());
      print(response.toString());
      var Msg = json.decode(response.toString());
      var code = Msg['code'];
      String toastMsg = "";
      if(code == 0){
        toastMsg = "取消成功";
        this.bean.status = 1.toString();
        setState(() {

        });

      }else{
        toastMsg = "取消失败";
      }
      EasyLoading.showToast(toastMsg,toastPosition: EasyLoadingToastPosition.bottom);
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
          //底部弹出表单
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.qr_code_outlined),
                    title: new Text("二维码"),
                    onTap: () async {
                      this._showDialog();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.delete_outline),
                    title: new Text("取消"),
                    onTap: () async {
                      this._cancel();
                    },
                  ),
                ],
              ),
            ),
          );
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
      case 0:
        widgetofStatus = Text(
          "待签到",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.lightGreen),
        );
        break;
      case 1:
        widgetofStatus = Text(
          "已取消",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
        );
        break;
      case 3:
        widgetofStatus = Text(
          "已完成",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
        );
        break;
      case 2:
        widgetofStatus = Text(
          "待签退",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.redAccent),
        );
        break;
      case 4:
        widgetofStatus = Text(
          "超时",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:  Colors.redAccent),
        );
        break;
      default:
        widgetofStatus = Text(
          "未知",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:  Colors.redAccent),
        );
    }
    return widgetofStatus;
  }

}



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

    //print(this.temp.id.toString());

    print(this.temp.id.toString()+"    "+response.toString());

    print("status: " +this.temp.status.toString());


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

  _cancel() async{
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();

    var response = await dio.delete(
        API + "/user/appointment?id="+this.temp.id.toString(),
        options: Options(headers: {
          "Auth": _token,
        }));

    if(response.statusCode == 200){
      print(this.temp.id.toString());
      print(response.toString());
      var Msg = json.decode(response.toString());
      var code = Msg['code'];
      String toastMsg = "";
      if(code == 0){
       toastMsg = "取消成功";
       this.bean.status = "3";

      }else{
        toastMsg = "取消失败";
      }
      EasyLoading.showToast(toastMsg,toastPosition: EasyLoadingToastPosition.bottom);
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
          print("status: " +this.temp.status.toString());
          this._showDialog();
        },
        onLongPress: (){
          //底部弹出表单
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.qr_code_outlined),
                    title: new Text("二维码"),
                    onTap: () async {
                      this._showDialog();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.delete_outline),
                    title: new Text("取消"),
                    onTap: () async {
                      this._cancel();

                    },
                  ),
                ],
              ),
            ),
          );
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
      case 0:
        widgetofStatus = Text(
          "待签到",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.lightGreen),
        );
        break;
      case 1:
        widgetofStatus = Text(
          "已取消",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
        );
        break;
      case 3:
       widgetofStatus = Text(
         "已完成",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
       );
        break;
      case 2:
        widgetofStatus = Text(
          "待签退",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.redAccent),
        );
        break;
      case 4:
        widgetofStatus = Text(
          "超时",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:  Colors.redAccent),
        );
        break;
      default:
        widgetofStatus = Text(
          "未知",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:  Colors.redAccent),
        );
    }
    return widgetofStatus;
  }
}
