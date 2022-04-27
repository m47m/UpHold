import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class FMRadioModel extends Object {
  int index;
  String text;

  FMRadioModel(this.index, this.text);
}


class GymArea {
  int id;
  String name;
  String introduction;

  GymArea({required this.id, required this.name,required  this.introduction});

  GymArea.fromJson(Map<String, dynamic> json):id = json['id'],
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

//预约表单
class Appointment {
  int? id;
  GymArea? gymArea;
  int? startTime;
  int? endTime;
  int? count;
  int? appointed;

  Appointment(
      {this.id,
        this.gymArea,
        this.startTime,
        this.endTime,
        this.count,
        this.appointed});

  Appointment.fromJson(Map<String, dynamic> json) {
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

//时间段类
class Period {
  String start_time;
  String end_time;
  String id;
  Period(this.start_time, this.end_time,this.id);
}


//日期对应的场所数组，以及场所对应的时间段数组
class dData {
  List<String> area;
  HashMap<String, List<Period>>? map;
  dData(this.area, this.map);

}

class Reservartion extends StatefulWidget {
  String title = " ";
  String GymId = " ";

  Reservartion({Key? key, required this.title,required this.GymId}) : super(key: key);

  @override
  _ReservartionState createState() => _ReservartionState(title,GymId);

//List<Appointment> list;
//Reservartion({Key? key,required this.list}) : super(key: key);

// @override
// _ReservartionState createState() => _ReservartionState(this.list);

}

class _ReservartionState extends State<Reservartion> {
  String API = "http://api.uphold.tongtu.xyz";

  var _futureBuilderFuture;

  String title = "";
  String GymId = " ";
  String ReservationStatus = "0/100人";
  String ReservationVenues = "";

  List<FMRadioModel> _datas = [];
  List<FMRadioModel> _datas2 = [];

  int groupValueOfTimeline = 1;
  int groupValueOfVenues = 1;

  _ReservartionState(this.title,this.GymId) {
  }

  List<Appointment> AppointmentList = [];
  // _ReservartionState( this.list){
  // }

  // List<String>? _list_date;
  // List<String>? _list_area;
  // List<Period>? _list_period;
  //
  // int groupValueOfPeriod = 1;
  // int groupValueOfArea = 1;
  // int groupValueOfDate = 1;


  // String ReservationStatus = "0/100人";
  // String ReservationArea = "";
  // String ReservationPeriod = "";
  // String ReservationDate = "";
  // String ReservationId = "";


  // //地点 ---> 日期 数组
  // HashMap<String,List<String>>? _map1;
  // //日期 -----> (地点 and 时间段) 数组
  // HashMap<String,List<dData>>? _map2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._futureBuilderFuture = _getData();
    initData();
  }

  Future _getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response = await dio.get(
        API + "/user/appointment/info?id="+this.GymId,
        options: Options(headers: {
          "Auth": _token,
        }));


    if (response.statusCode == 200){
      var msg= jsonDecode(response.toString());
      List AppointmentMsg = msg['data'];
      AppointmentList = AppointmentMsg.map((e) => new Appointment.fromJson(e)).toList();
    }

    for(var i in AppointmentList){
     print(i.startTime);
    }


  }

  void initData() {
    _datas.add(FMRadioModel(1, "9:00-11:00"));
    _datas.add(FMRadioModel(2, "11:00-13:00"));
    _datas.add(FMRadioModel(3, "13:00-15:00"));
    _datas.add(FMRadioModel(4, "15:00-17:00"));
    _datas.add(FMRadioModel(5, "17:00-19:00"));

    _datas2.add(FMRadioModel(1, "场所名称1"));
    _datas2.add(FMRadioModel(2, "场所名称2"));
    _datas2.add(FMRadioModel(3, "场所名称3"));
    _datas2.add(FMRadioModel(4, "场所名称4"));
    _datas2.add(FMRadioModel(5, "场所名称5"));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        //清除title左右padding，默认情况下会有一定的padding距离
        toolbarHeight: 50,
        //将高度定到44，设计稿的高度。为了方便适配，
        //推荐使用插件flutter_screenutil做屏幕的适配工作
        backgroundColor: Colors.white,
        elevation: 1,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        centerTitle: true,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        title: new Text(
          "预约",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     createColumn(),
      //     Container(
      //       width: 110,
      //       height: 45,
      //       margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      //       child: OutlinedButton(
      //           onPressed: () {},
      //           child: Text(
      //             "预约",
      //             style: TextStyle(
      //                 color: Colors.black,
      //                 fontWeight: FontWeight.w400,
      //                 fontSize: 17),
      //           )),
      //     ),
      //   ],
      // ),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            createColumn(),
            Container(
              width: 110,
              height: 45,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "预约",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 17),
                  )),
            ),
          ],
        );
    }
  }

  _buildListView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRadioOfTime(_datas[index]);
      },
      itemCount: _datas.length,
    );
  }

  _buildRadioOfTime(FMRadioModel model) {
    return Container(
      child: RadioListTile(
        value: model.index,
        groupValue: groupValueOfTimeline,
        title: Text(
          model.text,
          style: TextStyle(fontSize: 15),
        ),
        onChanged: (index) {
          this.groupValueOfTimeline = model.index;
          this.ReservationStatus = _datas[groupValueOfTimeline - 1].text;
          setState(() {});
        },
      ),
      height: 40,
    );
  }

  _buildListView2() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRadioOfVenues(_datas2[index]);
      },
      itemCount: _datas2.length,
    );
  }

  _buildRadioOfVenues(FMRadioModel model) {
    return Container(
      child: RadioListTile(
        value: model.index,
        groupValue: groupValueOfVenues,
        title: Text(
          model.text,
          style: TextStyle(fontSize: 15),
        ),
        onChanged: (index) {
          this.groupValueOfVenues = model.index;
          this.ReservationVenues = _datas2[groupValueOfVenues - 1].text;
          setState(() {});
        },
      ),
      height: 40,
    );
  }

  createColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 5, 10),
          child: Text(
            "健身健身房名称健身房名称",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            maxLines: 1,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
          child: Text("健身房地理位置健身房地理位置健身房地理位置健身房地理位置健身房地理位置",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
          child: Text(
              "当前预约状态：" +
                  '${this.ReservationStatus} ' +
                  '${this.ReservationVenues} ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text("选择日期：",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Container(
          height: 30,
          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text("",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text("选择时间：",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Container(
          height: 41.0 * _datas.length,
          child: _buildListView(),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text("选择场所：",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        Container(
          height: 41.0 * _datas.length,
          child: _buildListView2(),
        ),
      ],
    );
  }


}
