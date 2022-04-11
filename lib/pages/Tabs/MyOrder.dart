import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uphold/components/OrderCardItem.dart';


class OrderBean {
  String period;
  String title;
  String description;
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

  List _list = [];
  List<OrderBean> _orderList = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  _getData(){
    String jsonStr =
        '[{ "period":"9:00-12:00(2月23日)" ,"title":"健身房名称0","description":"场所信息场所信息场所信息场所信息场所信息场所信息","status":"2"},'
        '{ "period":"9:00-12:00(2月21日)" ,"title":"健身房名称1","description":"场所信息场所信息场所信息场场所信息场所信息场所信息场所信息场所信息场所信息所信息场所信息场所信场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息息","status":"2"},'
        '{ "period":"9:00-12:00(2月12日)" ,"title":"健身房名称2","description":"场所信息场所信息场所信息场所信息场场所信息场所信息场所信息场所信息场所信息场所信息所信息场所信息","status":"3"}'
        ',{ "period":"9:00-12:00(2月1日)" ,"title":"健身房名称3","description":"场所信息场所信息场所信息场所信场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息场所信息息场所信息场所信息","status":"1"}]';
    //将JSON字符串转为List
    _list = json.decode(jsonStr);

    for(int i = 0;i<_list.length;i++){
      _orderList.add(new OrderBean(period: _list[i]["period"], title: _list[i]["title"], description: _list[i]["description"], status: _list[i]["status"] ));
    }
  }

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
          title: new Text('ORDER' ,style: TextStyle(color: Colors.black),)
      ),
      body: this.buildListView(),
    );
  }

  buildListView(){
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          ///每个子Item的布局
          ///在这里是封装到了独立的 StatefulWidget
          return OrderCardItem(
            ///子Item对应的数据
            bean: _orderList[index],
            ///可选参数 子Item标识
            key: GlobalObjectKey(index),
          );
        },
      itemCount: this._orderList.length ,
    );
  }
}
