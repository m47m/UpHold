import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uphold/components/MsgCardItem.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class MsgBean {
  String title;
  String description;
  String from;
  String time;

  MsgBean(
      {required this.title, required this.description,
      required this.from,
      required this.time});
}

class Message extends StatelessWidget {
   Message({Key? key}) : super(key: key){
     _getData();
   }

  List _list = [];

  ///测试数据集合
  List<MsgBean> _testList = [];

  void initState() {
    _getData();
  }

  _getData() {
    //一个JSON格式的字符串
    String jsonStr =
        '[{"title":"通知标题1","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"平台","time":"2022-2-12 12:00"},'
        '{"title":"通知标题2","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"健身房名称","time":"2022-2-12 12:00"},'
        '{"title":"通知标题3","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"平台","time":"2022-2-12 12:00"},'
        '{"title":"通通知标题通知标题通知标题通知标题知标题4","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"健身房名称","time":"2022-2-12 12:00"},'
        '{"title":"通知标题5","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"平台","time":"2022-2-12 12:00"},'
        '{"title":"通知标题6","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"健身房名称","time":"2022-2-12 12:00"},'
        '{"title":"通知标题7","description":"    通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述通知描述","from":"健身房名称","time":"2022-2-12 12:00"}]';
    //将JSON字符串转为List
    _list = json.decode(jsonStr);

    for(int i = 0;i<_list.length;i++){
      _testList.add(new MsgBean(title: _list[i]["title"], description: _list[i]["description"], from: _list[i]["from"],time: _list[i]["time"] ));
    }
  }

   ///构建一个列表 ListView
   buildListView() {
     ///懒加载模式构建
     return ListView.builder(
       ///子Item的构建器
       itemBuilder: (BuildContext context, int index) {
         ///每个子Item的布局
         ///在这里是封装到了独立的 StatefulWidget
         return MsgCardItem(
           ///子Item对应的数据
           bean: _testList[index],
           ///可选参数 子Item标识
           key: GlobalObjectKey(index),
         );
       },
       ///ListView子Item的个数
       itemCount: _testList.length,
     );
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
          title: new Text('Message' ,style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 15, 5, 5),
        child: this.buildListView(),
      ),
    );
  }
}
