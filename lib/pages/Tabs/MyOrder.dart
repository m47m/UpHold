import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/components/OrderCardItem.dart';


class Order {
  int? id;
  int? user;
  GymAppointment? gymAppointment;
  int? status;
  int? inTime;
  int? outTime;

  Order(
      {this.id,
        this.user,
        this.gymAppointment,
        this.status,
        this.inTime,
        this.outTime});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    gymAppointment = json['gymAppointment'] != null
        ? new GymAppointment.fromJson(json['gymAppointment'])
        : null;
    status = json['status'];
    inTime = json['inTime'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    if (this.gymAppointment != null) {
      data['gymAppointment'] = this.gymAppointment!.toJson();
    }
    data['status'] = this.status;
    data['inTime'] = this.inTime;
    data['outTime'] = this.outTime;
    return data;
  }
}

class GymAppointment {
  int? id;
  GymArea? gymArea;
  int? startTime;
  int? endTime;
  int? count;
  int? appointed;

  GymAppointment(
      {this.id,
        this.gymArea,
        this.startTime,
        this.endTime,
        this.count,
        this.appointed});

  GymAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gymArea =
    json['gymArea'] != null ? new GymArea.fromJson(json['gymArea']) : null;
    startTime = json['startTime'];
    endTime = json['endTime'];
    count = json['count'];
    appointed = json['appointed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.gymArea != null) {
      data['gymArea'] = this.gymArea!.toJson();
    }
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['count'] = this.count;
    data['appointed'] = this.appointed;
    return data;
  }
}

class GymArea {
  int? id;
  String? name;
  String? introduction;

  GymArea({this.id, this.name, this.introduction});

  GymArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    introduction = json['introduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['introduction'] = this.introduction;
    return data;
  }
}

class OrderBean {
  String? period;
  String? title;
  String? description;
  String status;

  OrderBean(
      {
        required this.period,
        required this.title,
        required this.description,
        required this.status});
}


class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  List<Order> OrderList = [];
  List<OrderBean> _orderList = [];
  String API = "http://api.uphold.tongtu.xyz";
  var _futureBuilderFuture;


  @override
  void initState() {
    super.initState();
    this._futureBuilderFuture = initOrders();
    //_getData();
  }

  Future initOrders() async{
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();

    var response = await dio.get(
        API + "/user/appointment?page=0&size=10",
        options: Options(headers: {
          "Auth": _token,
        }));

    if(response.statusCode == 200){
      var msg = json.decode(response.toString());
      List OrderMsg = msg['data'];

      if(OrderMsg != null){
        OrderList = OrderMsg.map((e) => new Order.fromJson(e)).toList();
      }


    }

    for(var i in OrderList){

      String period = "";

      var startTime = DateTime.fromMillisecondsSinceEpoch(i.gymAppointment!.startTime!);
      var endTime = DateTime.fromMillisecondsSinceEpoch(i.gymAppointment!.endTime!);


      period = startTime.toString().substring(11, 16)+"-"+endTime.toString().substring(11, 16)+"("+ startTime.toString().substring(0,10) +")";

      //_orderList.add(new OrderBean(period: period, title: i.gymAppointment!.gymArea!.name, description: i.gymAppointment!.gymArea!.introduction, status: i.status.toString()));
      _orderList.insert(0, new OrderBean(period: period, title: i.gymAppointment!.gymArea!.name, description: i.gymAppointment!.gymArea!.introduction, status: i.status.toString()));
    }

  }

  // _getData(){
  //   String jsonStr =
  //       '[{ "period":"9:00-12:00(2月23日)" ,"title":"健身房名称0","description":"场所信息场所信息场所信息场所信息场所信息场所信息","status":"2"},'
  //       '{ "period":"9:00-12:00(2月21日)" ,"title":"健身房名称1","description":"场所信息场所信息场所信息场场所信息场所信息场所信息场所信息场所信息场所信息所信息场所信息场所信场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息息","status":"2"},'
  //       '{ "period":"9:00-12:00(2月12日)" ,"title":"健身房名称2","description":"场所信息场所信息场所信息场所信息场场所信息场所信息场所信息场所信息场所信息场所信息所信息场所信息","status":"3"}'
  //       ',{ "period":"9:00-12:00(2月1日)" ,"title":"健身房名称3","description":"场所信息场所信息场所信息场所信场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息息场所信息场所信息","status":"1"}]';
  //   //将JSON字符串转为List
  //   _list = json.decode(jsonStr);
  //
  //   for(int i = 0;i<_list.length;i++){
  //     _orderList.add(new OrderBean(period: _list[i]["period"], title: _list[i]["title"], description: _list[i]["description"], status: _list[i]["status"] ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,  //清除title左右padding，默认情况下会有一定的padding距离
          toolbarHeight: 55, //将高度定到44，设计稿的高度。为了方便适配，
          //推荐使用插件flutter_screenutil做屏幕的适配工作
          backgroundColor: Colors.white,
          elevation: 1,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          centerTitle: true,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          title: new Text('ORDER' ,style: TextStyle(color: Colors.black),)
      ),
     // body: this.buildListView(),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
      ),
    );
  }

  buildListView(){
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          ///每个子Item的布局
          ///在这里是封装到了独立的 StatefulWidget
          return OrderItem(
            ///子Item对应的数据
            bean: _orderList[index],

            temp: OrderList[this._orderList.length -1 - index],

            ///可选参数 子Item标识
            key: GlobalObjectKey(index),

            context: this.context,
          );
        },
      itemCount: this._orderList.length ,
    );
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
        EasyLoading.show(status: 'loading...',);
        return Center(
          //child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print('done');
        EasyLoading.dismiss();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return Container(child: this.buildListView());
    }
  }

}
