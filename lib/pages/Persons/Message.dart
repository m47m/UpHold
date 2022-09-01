import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/Utils/OverScrollBehavior.dart';
import 'package:uphold/components/MsgCardItem.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class MessageJsonBean {
  int? id;
  // String message;
  // Gym? gym;
  String title;
  String message;
  Gym? gym;
  String publishAt;

  MessageJsonBean({this.id, required this.message, required this.title,required this.publishAt, this.gym});

  MessageJsonBean.fromJson(Map<String, dynamic> json)
      : message = json['message'],publishAt = json['publishAt'],title = json['title']
  {
    id = json['id'];
    gym = json['gym'] != null ? new Gym.fromJson(json['gym']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    if (this.gym != null) {
      data['gym'] = this.gym!.toJson();
    }
    data['publishAt'] = this.publishAt;
    return data;
  }
}

class Gym {
  int? id;
  String name;
  String? introduction;
  Location? location;
  String? detailLocation;
  int? longitude;
  int? latitude;
  String? mainPhone;
  String? sparePhone;
  int? status;
  String? businessLicence;
  List<GymAreas>? gymAreas;
  List<MembershipCards>? membershipCards;

  Gym(
      {this.id,
      required this.name,
      this.introduction,
      this.location,
      this.detailLocation,
      this.longitude,
      this.latitude,
      this.mainPhone,
      this.sparePhone,
      this.status,
      this.businessLicence,
      this.gymAreas,
      this.membershipCards});

  Gym.fromJson(Map<String, dynamic> json) : name = json['name'] {
    id = json['id'];
    introduction = json['introduction'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    detailLocation = json['detailLocation'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    mainPhone = json['mainPhone'];
    sparePhone = json['sparePhone'];
    status = json['status'];
    businessLicence = json['businessLicence'];
    if (json['gymAreas'] != null) {
      gymAreas = <GymAreas>[];
      json['gymAreas'].forEach((v) {
        gymAreas!.add(new GymAreas.fromJson(v));
      });
    }
    if (json['membershipCards'] != null) {
      membershipCards = <MembershipCards>[];
      json['membershipCards'].forEach((v) {
        membershipCards!.add(new MembershipCards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['introduction'] = this.introduction;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['detailLocation'] = this.detailLocation;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['mainPhone'] = this.mainPhone;
    data['sparePhone'] = this.sparePhone;
    data['status'] = this.status;
    data['businessLicence'] = this.businessLicence;
    if (this.gymAreas != null) {
      data['gymAreas'] = this.gymAreas!.map((v) => v.toJson()).toList();
    }
    if (this.membershipCards != null) {
      data['membershipCards'] =
          this.membershipCards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  int? adcode;
  String? name;

  Location({this.adcode, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    adcode = json['adcode'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adcode'] = this.adcode;
    data['name'] = this.name;
    return data;
  }
}

class GymAreas {
  int? id;
  String? name;
  String? introduction;

  GymAreas({this.id, this.name, this.introduction});

  GymAreas.fromJson(Map<String, dynamic> json) {
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

class MembershipCards {
  int? id;
  String? name;
  int? duration;
  int? price;
  int? gym;

  MembershipCards({this.id, this.name, this.duration, this.price, this.gym});

  MembershipCards.fromJson(Map<String, dynamic> json) {
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

class MsgBean {
  String title;
  String description;
  String from;
  String time;

  MsgBean(
      {required this.title,
      required this.description,
      required this.from,
      required this.time});
}

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List _list = [];

  ///测试数据集合
  List<MsgBean> _testList = [];
  List<MessageJsonBean> _msgList = [];
  String API = "http://120.53.102.205";
  var _futureBuilderFuture;

  int page = 0;
  int size = 20;

  int i = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    this.page = 0;
    this.size = 8;
    setState(() {
      //this._initListData();
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 200));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //this._getData();
    if (mounted)
      setState(() {
        this.page++;
        // _loadListData();
      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _futureBuilderFuture = _initMessage();
    super.initState();
  }

  _initMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString("user");
    String? _token = prefs.getString("token");
    var dio = Dio();

    try {
      final response = await dio.get(
          API +
              "/user/notification?page=" +
              this.page.toString() +
              "&size=" +
              this.size.toString(),
          options: Options(headers: {
            "Auth": _token,
          }));

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());

        List MsgList = msg['data'];

        _msgList = MsgList.map((e) => new MessageJsonBean.fromJson(e)).toList();
      }

      for (var i in _msgList) {
        _testList.add(new MsgBean(
            title: i.title,
            description: i.message,
            from: i.gym!.name,
            time: i.publishAt));
      }
    } on DioError catch (e) {
      print(e);
      print("Response StatusCode: " + e.response!.statusCode.toString());
      this.i = 1;
    }
  }

  ///构建一个列表 ListView
  buildListView() {
    if (this.i == 1) {
      return Center(
        child: Text("出现了些问题...404"),
      );
    } else {
      if (this._msgList.isEmpty) {
        return Center(
          child: Text("暂无数据"),
        );
      } else {///懒加载模式构建
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
        );}
    }
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
          'Message',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 15, 5, 5),
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: _buildFuture,
        ),
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
        EasyLoading.show(
          status: 'loading...',
        );
        return Center(
            //child: CircularProgressIndicator(),
            );
      case ConnectionState.done:
        print('done');
        EasyLoading.dismiss();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        // if(this._gymList.isEmpty){
        //   return
        //       Center(
        //         child: Text("出现了点问题..."),
        //       );
        // }else{
        return ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              //header: WaterDropMaterialHeader(backgroundColor:Colors.blueAccent),
              header: MaterialClassicHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("上拉加载");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("加载失败！点击重试！");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("松手,加载更多!");
                  } else {
                    body = Text("没有更多数据了!");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: this.buildListView(),
            ));
    }
    // }
  }
}
