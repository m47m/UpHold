import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/Utils/OverScrollBehavior.dart';
import 'package:uphold/components/AdCardItem.dart';
import 'package:uphold/components/GymCardItem.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class GymBean {
  late int id;
  String name;
  String introduction;
  Location? location;
  String? detailLocation;
  String? mainPhone;
  String? sparePhone;
  int? status;
  String? businessLicence;
  List<GymAreas>? gymAreas;
  List<MembershipCards>? membershipCards;

  GymBean(
      {required this.id,
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

  GymBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        introduction = json['introduction'],
        name = json['name'] {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
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
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['detailLocation'] = this.detailLocation;
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
  int id;
  String name;
  String introduction;

  GymAreas({required this.id, required this.name, required this.introduction});

  GymAreas.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        introduction = json['introduction'] {}

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
  String imgURL;
  String description;
  bool isCollect;

  TestBean(
      {required this.title,
      required this.imgURL,
      required this.description,
      required this.isCollect});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //页面数据集合
  List<TestBean> _testList = [];

  //实际数据集合
  List<GymBean> _gymList = [];

  List<AdBean> _adList = [];

  String token = "1";
  String API = "http://120.53.102.205";
  int _page = 1; //加载的页数
  bool isLoading = false; //是否正在加载数据
  var _futureBuilderFuture;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int page = 0;
  int size = 8;

  int i = 0;

  String dropdownValue = '随机推荐';

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    this.page = 0;
    this.size = 8;
    setState(() {
      this._initListData();
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
        _loadListData();
      });
    _refreshController.loadComplete();
  }

  Future _getData() async {
    return Future.wait([_initAD(), _initListData()]);
  }

  @override
  void initState() {
    //_futureBuilderFuture = _initListData();
    _futureBuilderFuture = _getData();
    super.initState();
  }

  _loadListData() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();
    List<int> ids = [];
    var response1 = await dio.get(API + "/user/info",
        options: Options(headers: {
          "Auth": this.token,
        }));

    if (response1.statusCode == 200) {
      var _PersonMsg = json.decode(response1.toString());
      List collection = _PersonMsg['data']['collection'];
      for (var i in collection) {
        ids.add(i['id']);
      }
    }

    final response = await dio.get(
        API +
            "/gym/list?page=" +
            this.page.toString() +
            "&size=" +
            this.size.toString(),
        options: Options(headers: {
          "Auth": this.token,
        }));

    if (response.statusCode == 200) {
      var msg = jsonDecode(response.toString());
      List GymMsg = msg['data'];
      var temp = GymMsg.map((e) => new GymBean.fromJson(e)).toList();

      this._gymList.addAll(temp);
      for (var i in temp) {
        _testList.add(TestBean(
            title: i.name,
            imgURL: API + "/gym/headshot/" + i.id.toString(),
            description: i.introduction,
            isCollect: ids.contains(i.id)));
      }
    }
  }

  _uploadListData(String newValue) async {
    this.dropdownValue = newValue;
    // this._gymList.clear();
    // this._testList.clear();

    print("uploadListData:" + newValue);

    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    this._testList.clear();
    this._gymList.clear();
    this.page = 0;
    this.size = 8;

   // setState(() {
   //   EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
   //   EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
   //   EasyLoading.show(
   //     status: 'loading...',
   //   );
   // });


    var dio = Dio();
    List<int> ids = [];

    try {
      //获取收藏健身房列表
      var response1 = await dio.get(API + "/user/info",
          options: Options(headers: {
            "Auth": this.token,
          }));

      if (response1.statusCode == 200) {
        var _PersonMsg = json.decode(response1.toString());
        List collection = _PersonMsg['data']['collection'];
        for (var i in collection) {
          ids.add(i['id']);
        }
      }
      final response;

      if (newValue == '按热度排序') {
        response = await dio.get(API + "/gym/list/hot?adcode=" + "110101",
            options: Options(headers: {
              "Auth": this.token,
            }));
      } else if (newValue == '按距离排序') {
        response = await dio.get(
            API + "/gym/list/loc?adcode=" + "110101"+"&longitude="+"39.916527"+"&latitude"+"116.397128",
            options: Options(headers: {
              "Auth": this.token,
            }));
      } else {
        response = await dio.get(
            API +
                "/gym/list?page=" +
                this.page.toString() +
                "&size=" +
                this.size.toString(),
            options: Options(headers: {
              "Auth": this.token,
            }));
      }
      if (response.statusCode == 200) {
        this._testList.clear();
        this._gymList.clear();
        var msg = jsonDecode(response.toString());
        List GymMsg = msg['data'];
        _gymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();
      }

      for (var i in _gymList) {
        _testList.add(TestBean(
            title: i.name,
            description: i.introduction,
            isCollect: ids.contains(i.id),
            imgURL: API + "/gym/headshot/" + i.id.toString()));
      }
    } on DioError catch (e) {
      print(e);
      print("Response StatusCode: " + e.response!.statusCode.toString());

      this.i = 1;
    }

    setState(() {
      EasyLoading.dismiss();
    });
  }

  _searchListData(String value) {
    print("搜索内容：" + value.toString());

    // this._gymList.clear();
    // this._testList.clear();

    // final prefs = await SharedPreferences.getInstance();
    // String? _token = prefs.getString("token");
    // if (_token != null) {
    //   this.token = _token;
    // }
    //
    // var dio = Dio();
    // List<int> ids = [];
    //
    // try {
    //   var response1 = await dio.get(API + "/user/info",
    //       options: Options(headers: {
    //         "Auth": this.token,
    //       }));
    //
    //   if (response1.statusCode == 200) {
    //     var _PersonMsg = json.decode(response1.toString());
    //     List collection = _PersonMsg['data']['collection'];
    //     for (var i in collection) {
    //       ids.add(i['id']);
    //     }
    //   }
    //
    //   final response = await dio.get(
    //       API +
    //           "/gym/list?page=" +
    //           this.page.toString() +
    //           "&size=" +
    //           this.size.toString(),
    //       options: Options(headers: {
    //         "Auth": this.token,
    //       }));
    //
    //   if (response.statusCode == 200) {
    //     this._testList.clear();
    //     this._gymList.clear();
    //     var msg = jsonDecode(response.toString());
    //     List GymMsg = msg['data'];
    //     _gymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();
    //   }
    //
    //   for (var i in _gymList) {
    //     _testList.add(TestBean(
    //         title: i.name,
    //         description: i.introduction,
    //         isCollect: ids.contains(i.id)));
    //   }
    // } on DioError catch (e) {
    //   print(e);
    //   print("Response StatusCode: " + e.response!.statusCode.toString());
    // }
  }

  Future _initListData() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();
    List<int> ids = [];

    try {
      var response1 = await dio.get(API + "/user/info",
          options: Options(headers: {
            "Auth": this.token,
          }));

      if (response1.statusCode == 200) {
        var _PersonMsg = json.decode(response1.toString());
        List collection = _PersonMsg['data']['collection'];
        for (var i in collection) {
          ids.add(i['id']);
        }
      }

      print("response1 result " + response1.toString());

      final response = await dio.get(
          API +
              "/gym/list?page=" +
              this.page.toString() +
              "&size=" +
              this.size.toString(),
          options: Options(headers: {
            "Auth": this.token,
          }));

      print("response result " + response.toString());
      if (response.statusCode == 200) {
        this._testList.clear();
        this._gymList.clear();
        var msg = jsonDecode(response.toString());
        List GymMsg = msg['data'];
        _gymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();
      }

      for (var i in _gymList) {
        _testList.add(TestBean(
            title: i.name,
            imgURL: API + "/gym/headshot/" + i.id.toString(),
            description: i.introduction,
            isCollect: ids.contains(i.id)));
      }
    } on DioError catch (e) {
      print(e);
      print("Response StatusCode: " + e.response!.statusCode.toString());
      this.i = 0;
    }
  }

  Future _initAD() async {}

  ///构建一个列表 ListView
  buildListView() {
    if(this.i == 1){
      return Center(
        child: Text("出现了点问题..."),
      );
    }else{
      if (this._gymList.isEmpty) {
        return Center(
          child: Text("加载中..."),
        );
      } else {
        return ListView.separated(
          itemCount: _testList.length,
          separatorBuilder: (context, index) {
            return ADCardItem();
            // if ((index + 1) % 1 == 0) {
            //   return ADCardItem();
            //   //return AdCardItem( bean: _adList[index ~/ 4]);
            //   // return Container(
            //   //   height: 100,
            //   //   color: Colors.yellow,
            //   //   child: Text('it is ads'),
            //   // );
            // } else {
            //   return Container();
            // }
          },
          itemBuilder: (context, index) {
            return GardCardItem(
              ///子Item对应的数据
              bean: _testList[index],
              temp: _gymList[index],

              ///可选参数 子Item标识
              // key: GlobalObjectKey(index),
            );
          },
        );
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        //清除title左右padding，默认情况下会有一定的padding距离
        toolbarHeight: 105,
        //将高度定到44，设计稿的高度。为了方便适配，
        //推荐使用插件flutter_screenutil做屏幕的适配工作
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        title: Container(
            alignment: Alignment.center,
            //color: Colors.red,
            height: 110,
            width: 380,
//           padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Column(
              children: [
                Container(
                  width: 280,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
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
                    onSubmitted: (value) async {
                      setState(() {
                        this._searchListData(value);
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 15,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        // color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          //dropdownValue = newValue!;
                          this._uploadListData(newValue!);
                        });
                      },
                      items: <String>['随机推荐', '按热度排序', '按距离排序']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                )
              ],
            )),
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
