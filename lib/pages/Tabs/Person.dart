import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Persons/Collections.dart';
import 'package:uphold/pages/Persons/Message.dart';
import 'package:uphold/pages/Persons/Record.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';
import '../Login.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  String user = "默认";
  String token = "1";
  String saying = "多少事，从来急，天地转，光阴迫，一万年太久，只争朝夕多少事，从来急，天地转，光阴迫，一万年太久，只争朝夕";
  String sayingApi = "https://v1.hitokoto.cn/?c=k";

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", false);
    print("logout");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? _user = prefs.getString("user");
    String? _token = prefs.getString("token");
    // print("_user:" + _user!);
    // print("_token:" + _token!);
    if (_user != null) {
      this.user = _user;
    }
    if (_token != null) {
      this.token = _token;
    }

    var url = Uri.parse(this.sayingApi);
    var response = await http.get(url);
    print('Response body: ${response.body}');

    var responseJson = json.decode(response.body);
    Map<String, dynamic> SayingMsg = responseJson;
    this.saying = SayingMsg['hitokoto'].toString();

  }

  @override
  void initState() {
    // TODO: implement initState
    _initUser();
    super.initState();
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
          title: new Text(
            'PERSON',
            style: TextStyle(color: Colors.black),
          )),

      body: FutureBuilder(
        future: this._initUser(),
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
            //阴影
            shape: const RoundedRectangleBorder(
              //形状
              //修改圆角
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: Colors.white,
            //颜色
            margin: EdgeInsets.all(10),
            //margin
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Colors.blue,
                        image: DecorationImage(
                          //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                            image: AssetImage('images/a.jpg'),
                            fit: BoxFit.cover)),
                    width: 65,
                    height: 75,
                  ),
                  title: Text('用户名：' + '${this.user}'),
                  subtitle: Text('手机号：'),
                  trailing: Container(
                    width: 100,
                    height: 40,
                    child: OutlinedButton(
                        onPressed: () {
                          _logout();
                        },
                        child: Text(
                          "退出登录",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 17),
                        )),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("我的收藏");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Collections()));
                            },
                            child: Column(
                              children: [
                                Icon(Icons.collections),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("我的收藏")
                              ],
                            )),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("办卡记录");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Record()));
                            },
                            child: Column(
                              children: [
                                Icon(Icons.access_time),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("办卡记录")
                              ],
                            )),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("我的消息");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Message()));
                            },
                            child: Column(
                              children: [
                                Icon(Icons.message_outlined),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("我的消息")
                              ],
                            )),
                      ),
                      Container(
                        child: InkWell(
                            onTap: () {
                              print("申请教练");
                            },
                            child: Column(
                              children: [
                                Icon(Icons.upload_outlined),
                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                Text("申请教练")
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
        Container(
          width: 350,
          alignment: Alignment.center,
          child:  Text(this.saying),
          // child:  Row(
          //   mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     // Container(
          //     //   width:320,
          //     //   child: Text(this.saying) ,
          //     // )
          //     Text(this.saying)
          //   ],
          // ),
        )


      ],
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
      //               "退出登录",
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
