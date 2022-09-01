import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Reservartion extends StatefulWidget {
  String title = " ";
  String introduction = " ";
  String GymId = " ";

  Reservartion({Key? key, required this.title, required this.introduction, required this.GymId})
      : super(key: key);

  @override
  _ReservartionState createState() => _ReservartionState(title, introduction,GymId);

//List<Appointment> list;
//Reservartion({Key? key,required this.list}) : super(key: key);

// @override
// _ReservartionState createState() => _ReservartionState(this.list);

}

class _ReservartionState extends State<Reservartion> {
  String API = "http://120.53.102.205";

  var _futureBuilderFuture;

  String title = "";
  String introduction = " ";
  String GymId = " ";
  String ReservationStatus = "0/0人";
  //String ReservationVenues = "";


  //int groupValueOfTimeline = 1;
  //int groupValueOfVenues = 1;

  _ReservartionState(this.title,this.introduction, this.GymId) {}

  List<Appointment> AppointmentList = [];

  List<String> Dates = [];
  //List<FMRadioModel> _list_date = [];
  List<FMRadioModel> _list_area = [];
  List<PeriodRadioModel> _list_period = [];

  //
  int groupValueOfPeriod = 0;
  int groupValueOfArea = 0;
  int groupValueOfDate = 0;

  //String ReservationStatus = "0/100人";
  String ReservationArea = "";
  String ReservationPeriod = "";
  String ReservationDate = "";
  String ReservationId = "";

  //地点 ---> 日期 数组
  HashMap<String, List<String>>? _map1 = new HashMap();

  //日期 -----> (地点 and 时间段) 数组
  HashMap<String, dData>? _map2 = new HashMap();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._futureBuilderFuture = _getData();
    //initData();
  }

  Future _getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response =
        await dio.get(API + "/user/appointment/info?id=" + this.GymId,
            options: Options(headers: {
              "Auth": _token,
            }));
    if (response.statusCode == 200) {
      var msg = jsonDecode(response.toString());
      List AppointmentMsg = msg['data'];
      AppointmentList =
          AppointmentMsg.map((e) => new Appointment.fromJson(e)).toList();
    }

    List<int> allDate = [];

    for (var i in AppointmentList) {
      var startTime = DateTime.fromMillisecondsSinceEpoch(i.startTime!);
      var endTime = DateTime.fromMillisecondsSinceEpoch(i.endTime!);
      var area = i.gymArea!.name;
      var date = startTime.toString().substring(0, 10);

      print("--------------------------------");
      print("area:" + area);
      print("date:" + date);
      print("startTime:" + startTime.toString().substring(11, 16));
      print("endTime:" + endTime.toString().substring(11, 16));
      //Period period = new Period(startTime.toString().substring(11,16), endTime.toString().substring(11,16), i.id!.toString());
      //_map1!.putIfAbsent(area, () => ({startTime.toString().substring(0,10)}.toList()));

      allDate.add(i.startTime!);

      //map1 构造
      // if (_map1!.containsKey(area)) {
      //   _map1![area]!.add(startTime.toString().substring(0, 10));
      // } else {
      //   _map1!.putIfAbsent(
      //       area, () => ({startTime.toString().substring(0, 10)}.toList()));
      // }

      //map2 构造
      if (_map2!.containsKey(date)) {

        //添加地区
        if(!_map2![date]!.area.contains(area)){
          _map2![date]!.area.add(area);
        }

        //添加地区所对应时间
        if (_map2![date]!.map.containsKey(area)) {
          _map2![date]!.map[area]!.add(new Period(
              startTime.toString().substring(11, 16),
              endTime.toString().substring(11, 16),
              i.id.toString()));
        } else {
          _map2![date]!.map.putIfAbsent(
              area,
              () => {
                    new Period(startTime.toString().substring(11, 16),
                        endTime.toString().substring(11, 16), i.id.toString())
                  }.toList());
        }
      } else {
        List<String> _area = [];
        _area.add(area);

        List<Period> _period = [];
        _period.add(new Period(startTime.toString().substring(11, 16),
            endTime.toString().substring(11, 16), i.id.toString()));

        HashMap<String, List<Period>> _map = new HashMap();
        _map.putIfAbsent(area, () => _period);

        // List<dData> _dData = [];
        // _dData.add(new dData(_area, _map));

        _map2!.putIfAbsent(date, () => new dData(_area, _map));
      }
    }

    var temp = allDate.toSet().toList();
    temp.sort();


    for (var i in temp) {
      this.Dates.add(
          DateTime.fromMillisecondsSinceEpoch(i).toString().substring(0, 10));
    }

    this.Dates = this.Dates.toSet().toList();
    this.groupValueOfDate = 0;
    this.ReservationDate = this.Dates[this.groupValueOfDate];

    print("--------------------------------");
    print(this.Dates);
    print(this.ReservationDate);

    UpdateArea();
    UpdatePeriod();
  }

  void UpdateArea() {

    this._list_area.clear();
    print("--------------------------------");
    print(this._map2![this.ReservationDate]!.area);

    //初始化地点数组
    for (int i = 0; i < this._map2![this.ReservationDate]!.area.length; i++) {
      this
          ._list_area
          .add(new FMRadioModel(i, this._map2![this.ReservationDate]!.area[i]));
    }



    this.groupValueOfArea = 0;
    this.ReservationArea = this._list_area[groupValueOfArea].text;


    // //根据groupValueOfArea初始化日期数组
    //
    // for(int i = 0;i<this._map1![ReservationArea]!.length;i++){
    //   this._list_date.add(new FMRadioModel(i, this._map1![this._list_area[groupValueOfArea]]![i]));
    // }
    // this.groupValueOfDate = 0;
    // this.ReservationDate = this._list_date[groupValueOfDate].text;
    //

    //根据groupValueOfArea和groupValueOfDate初始化时间段数组
    // for (int i = 0;
    //     i < this._map2![ReservationDate]!.map[ReservationArea]!.length;
    //     i++) {
    //   this._list_period.add(new PeriodRadioModel(
    //       i,
    //       this._map2![ReservationDate]!.map[ReservationArea]![i].end_time +
    //           " - " +
    //           this._map2![ReservationDate]!.map[ReservationArea]![i].start_time,
    //       this._map2![ReservationDate]!.map[ReservationArea]![i].id));
    // }
    // this.groupValueOfPeriod = 0;
    // this.ReservationPeriod = this._list_period[groupValueOfPeriod].text;
    setState(() {});
  }

  void UpdatePeriod(){
    this._list_period.clear();

    //根据groupValueOfArea和groupValueOfDate初始化时间段数组
    for (int i = 0;
    i < this._map2![ReservationDate]!.map[ReservationArea]!.length;
    i++) {
      this._list_period.add(new PeriodRadioModel(
          i,
          this._map2![ReservationDate]!.map[ReservationArea]![i].end_time + " - " + this._map2![ReservationDate]!.map[ReservationArea]![i].start_time,
          this._map2![ReservationDate]!.map[ReservationArea]![i].id));
    }
    this.groupValueOfPeriod = 0;
    this.ReservationPeriod = this._list_period[groupValueOfPeriod].text;
    this.ReservationId = this._list_period[groupValueOfPeriod].id;

    UpdateState();
  }

  void Order(){
    print("---------------------------");
    print("预约ID = "+this.ReservationId);
    this.UpdateOrder();
    //this.UpdateState();
  }

  UpdateOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response =
        await dio.post(API + "/user/appointment?id=" + this.ReservationId,
        options: Options(headers: {
          "Auth": _token,
        }));
    if (response.statusCode == 200) {
      var msg = json.decode(response.toString());
      var code = msg['code'];
      String toastMsg = code == 0 ? "预约成功":"预约失败";

      EasyLoading.showToast(toastMsg,toastPosition: EasyLoadingToastPosition.bottom);
    }

    this.UpdateState();
  }

  UpdateState() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response =
        await dio.get(API + "/user/appointment/info?appointment=" + this.ReservationId,
        options: Options(headers: {
          "Auth": _token,
        }));
    if (response.statusCode == 200) {
      var msg = jsonDecode(response.toString());
      List AppointmentMsg = msg['data'];
      AppointmentList =
          AppointmentMsg.map((e) => new Appointment.fromJson(e)).toList();
    }

   this.ReservationStatus =  AppointmentList[0].appointed.toString()+"/"+AppointmentList[0].count.toString()+"人";
    setState(() {   });
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

      body: DirectSelectContainer(
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: _buildFuture,
        ),
      ),

    );
  }

  //future
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
          this._buildColumn(),
          Container(
            width: 120,
            height: 45,
            margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  Order();
                },
                child: Text(
                  "预约",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
          ),
        ],
      );
    }
  }

  //global layout
  _buildColumn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 30, 5, 10),
            child: Text(
              this.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              maxLines: 1,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 5, 10),
            child: Text("健身房描述："+this.introduction,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 5, 10),
            child: Text(
                "当前预约状态：" + this.ReservationStatus,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text("选择日期：",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),

        this._createDatePadding(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text("选择场所：",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
          Container(
            height: 41.0 * this._list_area.length,
            child: _buildListView2(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text("选择时间：",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
          Container(
            height: 41.0 * this._list_period.length,
            child: _buildListView(),
          ),
        ],
      ),
    );
  }
  //select date layout
  _createDatePadding(){
    return  Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Container(
        decoration: _getShadowDecoration(),
        child: Card(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        child: DirectSelectList<String>(
                          ///取值
                            values: this.Dates,
                            ///开始滑动时监听
                            onUserTappedListener: () {
                              print("onUserTappedListener");
                            },
                            ///设置默认值
                            defaultItemIndex: 0,
                            ///设置item样式
                            itemBuilder: (String value) =>
                                getDropDownMenuItem(value),
                            ///选择过程中的组件装饰器
                            focusedItemDecoration: _getDslDecoration(),
                            ///选中值监听
                            onItemSelectedListener: (item, index, context) {

                              //更改地点和时间段数组
                              this.ReservationDate = item;
                              this.UpdateArea();
                              this.UpdatePeriod();
                               setState(() {
                               });
                            }),
                        padding: EdgeInsets.only(left: 22))),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _getDropdownIcon(),
                )
              ],
            )),
      ),
    );
  }
  //select area layout
  _buildListView2() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRadioOfVenues(this._list_area[index]);
      },
      itemCount: this._list_area.length,
    );
  }
  _buildRadioOfVenues(FMRadioModel model) {
    return Container(
      child: RadioListTile(
        value: model.index,
        groupValue: groupValueOfArea,
        title: Text(
          model.text,
          style: TextStyle(fontSize: 15),
        ),
        onChanged: (index) {
          this.groupValueOfArea = model.index;
          this.ReservationArea = this._list_area[groupValueOfArea].text;
          this._list_period.clear();

          //更改对应的时间段数组
          for (int i = 0; i < this._map2![ReservationDate]!.map[ReservationArea]!.length; i++) {
            this._list_period.add(new PeriodRadioModel(
                i,
                this._map2![ReservationDate]!.map[ReservationArea]![i].end_time + " - " + this._map2![ReservationDate]!.map[ReservationArea]![i].start_time,
                this._map2![ReservationDate]!.map[ReservationArea]![i].id));
          }
          this.groupValueOfPeriod = 0;
          this.ReservationPeriod = this._list_period[groupValueOfPeriod].text;


          setState(() {});
        },
      ),
      height: 40,
    );
  }

  //select period layout
  _buildListView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRadioOfTime(this._list_period[index]);
      },
      itemCount: this._list_period.length,
    );
  }
  _buildRadioOfTime(PeriodRadioModel model) {
    return Container(
      child: RadioListTile(
        value: model.index,
        groupValue: groupValueOfPeriod,
        title: Text(
          model.text,
          style: TextStyle(fontSize: 15),
        ),
        onChanged: (index) {
          //选择时间更新预约状态
          this.groupValueOfPeriod = model.index;
          this.ReservationPeriod = this._list_period[groupValueOfPeriod].text;
          this.ReservationId = this._list_period[groupValueOfPeriod].id;
          print("--------------------------------");
          print("id: " + this.ReservationId);
          this.UpdateState();
          setState(() {});
        },
      ),
      height: 40,
    );
  }


  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(
            "$value",
            style: TextStyle(fontSize: 16),
          );
        });
  }
  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }
  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black.withOpacity(0.06),
          spreadRadius: 1,
          offset: new Offset(0.0, 0.0),
          blurRadius: 15.0,
        ),
      ],
    );
  }
  Icon _getDropdownIcon() {
    return Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );
  }

  // createColumn() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 20, 5, 10),
  //         child: Text(
  //           "健身健身房名称健身房名称",
  //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
  //           maxLines: 1,
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
  //         child: Text("健身房地理位置健身房地理位置健身房地理位置健身房地理位置健身房地理位置",
  //             style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
  //       ),
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
  //         child: Text(
  //             "当前预约状态：" +
  //                 '${this.ReservationPeriod} ' +
  //                 '${this.ReservationArea} ',
  //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
  //       ),
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //         child: Text("选择日期：",
  //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
  //       ),
  //       Container(
  //         height: 30,
  //         margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //         child: Text("",
  //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
  //       ),
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //         child: Text("选择场所：",
  //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
  //       ),
  //       Container(
  //         height: 41.0 * this._list_area.length,
  //         child: _buildListView2(),
  //       ),
  //       Container(
  //         margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //         child: Text("选择时间：",
  //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
  //       ),
  //       Container(
  //         height: 41.0 * this._list_period.length,
  //         child: _buildListView(),
  //       ),
  //     ],
  //   );
  // }
}




class FMRadioModel extends Object {
  int index;
  String text;

  FMRadioModel(this.index, this.text);
}

class PeriodRadioModel {
  int index;
  String text;
  String id;

  PeriodRadioModel(this.index, this.text, this.id);
}

class GymArea {
  int id;
  String name;
  String introduction;

  GymArea({required this.id, required this.name, required this.introduction});

  GymArea.fromJson(Map<String, dynamic> json)
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

  Period(this.start_time, this.end_time, this.id);
}

//日期对应的场所数组，以及场所对应的时间段数组
class dData {
  List<String> area;
  HashMap<String, List<Period>> map;

  dData(this.area, this.map);
}