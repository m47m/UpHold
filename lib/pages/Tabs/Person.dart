import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/components/CodeDialog.dart';
import 'package:uphold/pages/Persons/Collections.dart';
import 'package:uphold/pages/Persons/Information.dart';
import 'package:uphold/pages/Persons/Message.dart';
import 'package:uphold/pages/Persons/Record.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';
import '../Login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Home.dart';

class PersonMsg {
  int? id;
  String phone;
  String nickname;
  String headshot;
  String sex;
  String age;
  List<Authorities>? authorities;
  bool? enabled;
  String? username;
  bool? credentialsNonExpired;
  bool? accountNonExpired;
  bool? accountNonLocked;

  PersonMsg(
      {required this.id,
      required this.phone,
      required this.nickname,
      required this.headshot,
      required this.sex,
      required this.age,
      this.authorities,
      this.enabled,
      this.username,
      this.credentialsNonExpired,
      this.accountNonExpired,
      this.accountNonLocked});

  PersonMsg.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        phone = json['phone'],
        nickname = json['nickname'],
        headshot = json['headshot'],
        sex = json['sex'],
        age = json['age'] {
    if (json['authorities'] != null) {
      authorities = <Authorities>[];
      json['authorities'].forEach((v) {
        authorities!.add(new Authorities.fromJson(v));
      });
    }
    enabled = json['enabled'];
    username = json['username'];
    credentialsNonExpired = json['credentialsNonExpired'];
    accountNonExpired = json['accountNonExpired'];
    accountNonLocked = json['accountNonLocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['nickname'] = this.nickname;
    data['headshot'] = this.headshot;
    data['sex'] = this.sex;
    data['age'] = this.age;
    if (this.authorities != null) {
      data['authorities'] = this.authorities!.map((v) => v.toJson()).toList();
    }
    data['enabled'] = this.enabled;
    data['username'] = this.username;
    data['credentialsNonExpired'] = this.credentialsNonExpired;
    data['accountNonExpired'] = this.accountNonExpired;
    data['accountNonLocked'] = this.accountNonLocked;
    return data;
  }
}

class Authorities {
  int? id;
  String? authority;

  Authorities({this.id, this.authority});

  Authorities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authority = json['authority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['authority'] = this.authority;
    return data;
  }
}

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  String user = "??????";
  String tel = "----";
  String token = "1";
  String API = "http://api.uphold.tongtu.xyz";
  String saying = "?????????????????????????????????????????????????????????????????????????????????";
  String sayingApi = "https://v1.hitokoto.cn/?c=k";
  //?????????????????????
  List<GymBean> CollectionList = [];

  var _futureBuilderFuture;

  // _showDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CodeDialog(CodeData: "CodeData");
  //       });
  // }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", false);
    print("logout");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  Future _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString("user");
    String? _token = prefs.getString("token");
    // print("_user:" + _user!);
    // print("_token:" + _token!);
    // if (_user != null) {
    //   this.user = _user;
    // }
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();

    final response = await dio.get(
        API + "/user/info",
        options: Options(headers: {
          "Auth": this.token,
        }));

    if(response.statusCode == 200){
      var _PersonMsg = json.decode(response.toString());
      var person = PersonMsg.fromJson(_PersonMsg['data']);
      this.user = person.nickname;
      this.tel = person.phone;

      List collection = _PersonMsg['data']['collection'];

      CollectionList =  collection.map((e) => new GymBean.fromJson(e)).toList();
    }

    // var url = Uri.parse(this.sayingApi);
    // var response = await http.get(url);
    // print('Response body: ${response.body}');
    //
    // var responseJson = json.decode(response.body);
    // Map<String, dynamic> SayingMsg = responseJson;
    // this.saying = SayingMsg['hitokoto'].toString();
  }

  Future _initSaying() async {
    var url = Uri.parse(this.sayingApi);
    var response = await http.get(url);
    print('Response body: ${response.body}');

    var responseJson = json.decode(response.body);
    Map<String, dynamic> SayingMsg = responseJson;
    this.saying = SayingMsg['hitokoto'].toString();
  }

  Future _getData() async {
    return Future.wait([_initUser(), _initSaying()]);
  }


  @override
  void initState() {
    // TODO: implement initState
    _futureBuilderFuture = _getData();
    super.initState();
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
          title: new Text(
            'PERSON',
            style: TextStyle(color: Colors.black),
          )),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
      ),
    );
  }

  Widget PersonCard() {
    return Column(
      children: [
        Container(
          child: Card(
            elevation: 3,
            //??????
            shape: const RoundedRectangleBorder(
              //??????
              //????????????
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: Colors.white,
            //??????
            margin: EdgeInsets.all(10),
            //margin
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.blue,
                          image: DecorationImage(
                            //FileImage ????????????   ???NetworkImage ??????  ???AssetImage??????
                              image: AssetImage('images/a.jpg'),
                              fit: BoxFit.cover)),
                      width: 65,
                      height: 75,
                    ),
                    title: Text('????????????' + '${this.user}'),
                    subtitle: Text('????????????${this.tel}'),
                    trailing: Container(
                      width: 100,
                      height: 40,
                      child: OutlinedButton(
                          onPressed: () {
                            _logout();
                          },
                          child: Text(
                            "????????????",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 17),
                          )),
                    ),
                  ),
                  onTap: (){
                    print("??????????????????");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Info()));
                  },
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      GestureDetector(
                        onTap: (){
                                  print("????????????");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Collections(collection: this.CollectionList,)));
                        },
                          child: Column(
                            children: [
                              Icon(Icons.collections),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                              Text("????????????")
                            ],
                          )
                      ),

                      Container(
                        child: InkWell(
                            onTap: () {
                              print("????????????");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Record()));
                            },
                            child: Column(
                              children: [
                                Icon(Icons.access_time),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("????????????")
                              ],
                            )),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("????????????");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Message()));

                            },
                            child: Column(
                              children: [
                                Icon(Icons.message_outlined),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("????????????")
                              ],
                            )),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("????????????");
                              //this._showDialog();
                            },
                            child: Column(
                              children: [
                                Icon(Icons.upload_outlined),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("????????????")
                              ],
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 80,
        ),

        GestureDetector(
          child: Container(
            width: 350,
            alignment: Alignment.center,
            child: Text(this.saying),
          ),
          onTap: (){
            this._initSaying();
            setState(() {

            });
          },
        )

      ],
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
        return PersonCard();
      // return Container(
      //   alignment: Alignment.center,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //           width: 320,
      //           height: 320,
      //           child: Column(
      //             children: [
      //               Text(this.user),
      //               Text(this.token),
      //             ],
      //           )),
      //       Container(
      //         width: 120,
      //         height: 50,
      //         child: OutlinedButton(
      //             onPressed: () {
      //               _logout();
      //             },
      //             child: Text(
      //               "????????????",
      //               style: TextStyle(
      //                   color: Colors.black,
      //                   fontWeight: FontWeight.w400,
      //                   fontSize: 17),
      //             )),
      //       ),
      //     ],
      //   ),
      // );
    }
  }
}
