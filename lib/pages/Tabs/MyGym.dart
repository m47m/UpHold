import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/components/MyGymCardItem.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class MembershipRegisters {
  int? id;
  int? user;
  MembershipCard? membershipCard;
  int? registerAt;

  MembershipRegisters(
      {this.id, this.user, this.membershipCard, this.registerAt});

  MembershipRegisters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    membershipCard = json['membershipCard'] != null
        ? new MembershipCard.fromJson(json['membershipCard'])
        : null;
    registerAt = json['registerAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    if (this.membershipCard != null) {
      data['membershipCard'] = this.membershipCard!.toJson();
    }
    data['registerAt'] = this.registerAt;
    return data;
  }
}

class MembershipCard {
  int? id;
  String? name;
  int? duration;
  int? price;
  int? gym;

  MembershipCard({this.id, this.name, this.duration, this.price, this.gym});

  MembershipCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    price = json['price'];
    gym = json['gym'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['gym'] = this.gym;
    return data;
  }
}

class MyGymBean {
  String title;
  String description;
  bool isCollect;

  MyGymBean(
      {required this.title,
      required this.description,
      required this.isCollect});
}

class MyGym extends StatefulWidget {
  const MyGym({Key? key}) : super(key: key);

  @override
  _MyGymState createState() => _MyGymState();
}

class _MyGymState extends State<MyGym> {
  List _list = [];
  List<MembershipRegisters> Registers = [];
  List<GymBean> MyGymList = [];

  ///测试数据集合
  List<MyGymBean> _testList = [];
  String API = "http://api.uphold.tongtu.xyz";

  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    this._futureBuilderFuture = initRegisters();
  }

  Future initRegisters() async {
    final prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString("user");
    String? _token = prefs.getString("token");

    var dio = Dio();

    final response = await dio.get(
        API + "/user/info",
        options: Options(headers: {
          "Auth": _token,
        }));

    if (response.statusCode == 200) {
      var _PersonMsg = json.decode(response.toString());
      List register = _PersonMsg['data']['membershipRegisters'];

      Registers = register.map((e) => new MembershipRegisters.fromJson(e)).toList();
    }

    //print(Registers[0].membershipCard!.gym);

    for(var i in Registers){
      print(i.membershipCard!.gym);

      var response = await dio.get(
          API + "/gym/info?id="+i.membershipCard!.gym.toString(),
          options: Options(headers: {
            "Auth": _token,
          }));

      if(response.statusCode == 200){
        var _GymMsg = json.decode(response.toString());
        GymBean gymBean = GymBean.fromJson(_GymMsg['data']);

        this.MyGymList.add(gymBean);

        //this._testList.add(new MyGymBean(title: gymBean.name, description: gymBean.introduction, isCollect: true));
      }

    }


  }


  _initList(GymBean gymBean) {
    // //一个JSON格式的字符串
    // String jsonStr =
    //     '[{"title":"健身房名称0","description":"健身房描述健身房描述健身房描述健身房房描述健身房描述健描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
    //     '{"title":"健身房名称1","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
    //     '{"title":"健身房名称2","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
    //     '{"title":"健身房名称3","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
    //     '{"title":"健身房名称4","description":"健身房描述健身房描述健身房描述健房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
    //     '{"title":"健身房名称5","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"}]';
    // //将JSON字符串转为List
    // _list = json.decode(jsonStr);
    //
    // for (int i = 0; i < _list.length; i++) {
    //   _testList.add(new MyGymBean(
    //       title: _list[i]["title"],
    //       description: _list[i]["description"],
    //       isCollect: true));
    // }
  }

  ///构建一个列表 ListView
  buildListView() {
    ///懒加载模式构建
    return ListView.builder(

      ///子Item的构建器
      itemBuilder: (BuildContext context, int index) {
        ///每个子Item的布局
        ///在这里是封装到了独立的 StatefulWidget
        return MyGymCardItem(

          ///子Item对应的数据
          temp: MyGymList[index],

          ///可选参数 子Item标识
          //key: GlobalObjectKey(index),
        );
      },

      ///ListView子Item的个数
      itemCount: MyGymList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          //清除title左右padding，默认情况下会有一定的padding距离
          toolbarHeight: 75,
          //将高度定到44，设计稿的高度。为了方便适配，
          //推荐使用插件flutter_screenutil做屏幕的适配工作
          backgroundColor: Colors.white,
          elevation: 1,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          centerTitle: true,
          //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
          title: new Text(
            'GYM',
            style: TextStyle(color: Colors.black),
          )),
      //body: Container(child: this.buildListView()),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
      ),
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
