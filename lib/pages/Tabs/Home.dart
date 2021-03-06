import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  //??????????????????
  List<TestBean> _testList = [];
  //??????????????????
  List<GymBean> _gymList = [];
  String token = "1";
  String API = "http://api.uphold.tongtu.xyz";
  int _page = 1; //???????????????
  bool isLoading = false; //????????????????????????
  var _futureBuilderFuture;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int page = 0;
  int size = 8;

  void _onRefresh() async{
    // monitor network fetch
     await Future.delayed(Duration(milliseconds: 1000));

     // this.page = 0;
     // this.size = 8;
     setState(() {
       //this._initListData();
     });

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 200));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //this._getData();
    if(mounted)
      setState(() {
        this.page++;
        _loadListData();
      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _futureBuilderFuture = _initListData();
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
    var response1 = await dio.get(
        API + "/user/info",
        options: Options(headers: {
          "Auth": this.token,
        }));

    if(response1.statusCode == 200){
      var _PersonMsg = json.decode(response1.toString());
      List collection = _PersonMsg['data']['collection'];
      for(var i in collection){
        ids.add(i['id']);
      }
    }

    final response = await dio.get(
        API + "/gym/list?page="+this.page.toString()+"&size="+this.size.toString(),
        options: Options(headers: {
          "Auth": this.token,
        }));

    if (response.statusCode == 200) {
      var msg= jsonDecode(response.toString());
      List GymMsg = msg['data'];
      var temp = GymMsg.map((e) => new GymBean.fromJson(e)).toList();

      this._gymList.addAll(temp);
      for(var i in temp){
        _testList.add(
            TestBean(
                title: i.name,
                description: i.introduction,
                isCollect: ids.contains(i.id))
        );
      }

    }
  }


  Future  _initListData() async {

    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();
    List<int> ids = [];
    var response1 = await dio.get(
        API + "/user/info",
        options: Options(headers: {
          "Auth": this.token,
        }));

    if(response1.statusCode == 200){
      var _PersonMsg = json.decode(response1.toString());
      List collection = _PersonMsg['data']['collection'];
      for(var i in collection){
        ids.add(i['id']);
      }
    }

    final response = await dio.get(
        API + "/gym/list?page="+this.page.toString()+"&size="+this.size.toString(),
        options: Options(headers: {
          "Auth": this.token,
        }));
    if (response.statusCode == 200) {
      this._testList.clear();
      this._gymList.clear();
      var msg= jsonDecode(response.toString());
      List GymMsg = msg['data'];
      _gymList = GymMsg.map((e) => new GymBean.fromJson(e)).toList();

    }

    for(var i in _gymList){
      _testList.add(
          TestBean(
              title: i.name,
              description: i.introduction,
              isCollect: ids.contains(i.id))
      );
    }




  }

  ///?????????????????? ListView
  buildListView() {
    ///?????????????????????
    return ListView.builder(
      ///???Item????????????
      itemBuilder: (BuildContext context, int index) {
        ///?????????Item?????????
        ///????????????????????????????????? StatefulWidget
        return GardCardItem(
          ///???Item???????????????
          bean: _testList[index],
          temp: _gymList[index],
          ///???????????? ???Item??????
          // key: GlobalObjectKey(index),
        );
      },
      ///ListView???Item?????????
      itemCount: _testList.length,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        //??????title??????padding?????????????????????????????????padding??????
        toolbarHeight: 75,
        //???????????????44?????????????????????????????????????????????
        //??????????????????flutter_screenutil????????????????????????
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        //??????title?????????????????????widget?????????????????????????????????????????????widget???
        title: Container(
          alignment: Alignment.center,
          height: 44,
          width: 280,
//           padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: '??????',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    /// ?????????????????????????????????????????????????????????????????????????????????
                    Radius.circular(5),
                  ),
                ),

                ///?????????????????????
                contentPadding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                ),
                prefixIcon: Icon(Icons.search)),
            onSubmitted: (value) {
              print("???????????????" + value.toString());
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
        print('???????????????????????????');
        return Text('???????????????????????????');
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
                  body =  Text("????????????");
                }
                else if(mode==LoadStatus.loading){
                  body =  CupertinoActivityIndicator();
                }
                else if(mode == LoadStatus.failed){
                  body = Text("??????????????????????????????");
                }
                else if(mode == LoadStatus.canLoading){
                  body = Text("??????,????????????!");
                }
                else{
                  body = Text("?????????????????????!");
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
