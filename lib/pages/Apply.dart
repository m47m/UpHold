import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Tabs/MyGym.dart';

import 'Reservation.dart';

class Apply extends StatefulWidget {

  String id;

  Apply({required this.id,Key? key}) : super(key: key);

  @override
  _ApplyState createState() => _ApplyState(this.id);
}

class _ApplyState extends State<Apply> {
  String id;
  var _futureBuilderFuture ;
   List<MembershipCard> _data =[];
   List<FMRadioModel> _list =[];
  int groupValue = 0;
  String  cardId = '';
  String API = "http://api.uphold.tongtu.xyz";

  _ApplyState(this.id){}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._futureBuilderFuture = _getData();
    //initData();
  }

  _getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response =
        await dio.get(API + "/gym/info?id=" + this.id,
        options: Options(headers: {
          "Auth": _token,
        }));

    if(response.statusCode == 200){
      var msg = jsonDecode(response.toString());
      List MembersMsg = msg['data']['membershipCards'];
      _data = MembersMsg.map((e) => new MembershipCard.fromJson(e)).toList();
    }
    
    for(int i = 0;i<this._data.length;i++){
      this._list.add(new FMRadioModel(i, this._data[i].name!));
    }
    this.groupValue = 0;
    this.cardId = _data[groupValue].id.toString();
  }

  _apply() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");

    var dio = Dio();
    final response =
        await dio.post(API + "/user/membership?id=" + this.cardId,
        options: Options(headers: {
          "Auth": _token,
        }));

    print(response.toString());

    EasyLoading.showToast("办卡成功",toastPosition: EasyLoadingToastPosition.bottom);

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
         "办卡",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),

        //leading: Icon(Icons.arrow_back, color: Colors.black,),
      ),
      body:  FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
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

            SizedBox(
              height: 80,
            ),

            this._buildColumn(),
            Container(
              width: 120,
              height: 45,
              margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                    print(this.cardId);
                    this._apply();
                  },
                  child: Text(
                    "办卡",
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

  _buildColumn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text("选择办卡种类：",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
          Container(
            height: 41.0 * this._list.length,
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  _buildListView() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildRadio(this._list[index]);
      },
      itemCount: this._list.length,
    );
  }
  _buildRadio(FMRadioModel model) {
    return Container(
      child: RadioListTile(
        value: model.index,
        groupValue: groupValue,
        title: Text(
          model.text,
          style: TextStyle(fontSize: 15),
        ), onChanged: (int? value) {
        this.cardId = _data[groupValue].id.toString();
      },
      ),
      height: 40,
    );
  }
}
