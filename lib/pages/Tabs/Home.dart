import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/Utils/OverScrollBehavior.dart';
import 'package:uphold/components/GymCardItem.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';



class GymBean {
  late int id;
  String name;
  String introduction;
  String? location;
  String? detailLocation;
  String? mainPhone;
  String? sparePhone;
  String? status;
  String? businessLicence;
  List<GymAreas>? gymAreas;
  List<MembershipCards>? membershipCards;

  GymBean(
      { required this.id,
        required this.name,
        required this.introduction,
        this.location,
        this.detailLocation,
        this.mainPhone,
        this.sparePhone,
        this.status,
        this.businessLicence,
        required this.gymAreas,
        this.membershipCards});

  GymBean.fromJson(Map<String, dynamic> json) :id = json['id'], introduction = json['introduction'],
        name = json['name']{
    location = json['location'];
    detailLocation = json['detailLocation'];
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
    data['location'] = this.location;
    data['detailLocation'] = this.detailLocation;
    data['mainPhone'] = this.mainPhone;
    data['sparePhone'] = this.sparePhone;
    data['status'] = this.status;
    data['businessLicence'] = this.businessLicence;

    if(this.gymAreas != null){
      data['gymAreas'] = this.gymAreas!.map((v) => v.toJson()).toList();
    }


    if (this.membershipCards != null) {
      data['membershipCards'] =
          this.membershipCards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GymAreas {
  int id;
  String name;
  String introduction;

  GymAreas({required this.id, required this.name,required  this.introduction});

  GymAreas.fromJson(Map<String, dynamic> json):id = json['id'],
  name = json['name'],
  introduction = json['introduction'] {

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

class TestBean {
  String title;
  String description;
  bool isCollect;

  TestBean(
      {required this.title,
      required this.description,
      required this.isCollect});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _list = [];

  ///测试数据集合
  List<TestBean> _testList = [];

  //实际数据集合
  List<GymBean> _gymList = [];

  String token = "1";

  String API = "http://api.uphold.tongtu.xyz";

  int _page = 1; //加载的页数

  bool isLoading = false; //是否正在加载数据

  //Future<String> _myString;

  var _futureBuilderFuture;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
     await Future.delayed(Duration(milliseconds: 1000));
     setState(() {
       this._initListData();
     });

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 300));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    this._getData();
    if(mounted)
      setState(() {
      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _futureBuilderFuture = _initListData();
    super.initState();
  }

  _getData() {
    //一个JSON格式的字符串
    String jsonStr =
        '[{"title":"健身房名称0","description":"健身房描述健身房描述健身房描述健身房房描述健身房描述健描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
        '{"title":"健身房名称1","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
        '{"title":"健身房名称2","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
        '{"title":"健身房名称3","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
        '{"title":"健身房名称4","description":"健身房描述健身房描述健身房描述健房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"0"},'
        '{"title":"健身房名称5","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"}]';
    //将JSON字符串转为List
    _list = json.decode(jsonStr);
    for (int i = 0; i < _list.length; i++) {
      _testList.add(new TestBean(
          title: _list[i]["title"],
          description: _list[i]["description"],
          isCollect: _list[i]["isCollect"] == "1" ? true : false));
    }
  }

  Future  _initListData() async {

     //this._getData();
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();
    final response = await dio.get(
      API + "/gym/list?page=0&size=10",
      options: Options(headers: {
        "Auth": this.token,
      }));

    if (response.statusCode == 200) {
      this._testList.clear();
      this._gymList.clear();
      var msg= jsonDecode(response.toString());
      List GymMsg = msg['data'];
     // List<GymBean> GymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();

      _gymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();

      for(var i in _gymList){
        _testList.add(
            TestBean(
            title: i.name,
            description: i.introduction,
            isCollect: false)
        );
      }
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
        return GardCardItem(
          ///子Item对应的数据
          bean: _testList[index],
          temp: _gymList[0],
          ///可选参数 子Item标识
          // key: GlobalObjectKey(index),
        );
      },
      ///ListView子Item的个数
      itemCount: _testList.length,

      //controller: _scrollController,
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
        centerTitle: true,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        title: Container(
          alignment: Alignment.center,
          height: 44,
          width: 280,
//           padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: '搜索',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                    Radius.circular(5),
                  ),
                ),

                ///设置内容内边距
                contentPadding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                ),
                prefixIcon: Icon(Icons.search)),
            onSubmitted: (value) {
              print("搜索内容：" + value.toString());
            },
          ),
        ),
      ),

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
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print('done');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return
          ScrollConfiguration(behavior: OverScrollBehavior(), child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            //header: WaterDropMaterialHeader(backgroundColor:Colors.blueAccent),
            header: MaterialClassicHeader(),
            footer: CustomFooter(
              builder: (BuildContext context,LoadStatus? mode){
                Widget body ;
                if(mode==LoadStatus.idle){
                  body =  Text("上拉加载");
                }
                else if(mode==LoadStatus.loading){
                  body =  CupertinoActivityIndicator();
                }
                else if(mode == LoadStatus.failed){
                  body = Text("加载失败！点击重试！");
                }
                else if(mode == LoadStatus.canLoading){
                  body = Text("松手,加载更多!");
                }
                else{
                  body = Text("没有更多数据了!");
                }
                return Container(
                  height: 55.0,
                  child: Center(child:body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: this.buildListView(),
          ));
    }
  }
}
