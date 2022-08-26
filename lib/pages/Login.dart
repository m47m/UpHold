import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Register.dart';
import 'dart:convert' ;
import 'Tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String tel = "";
  String password = "";
  String API = "http://api.tongtu.xyz";
  String API2 = "http://api.uphold.tongtu.xyz";

  _login() async {
    print("登录信息：tel："+tel+"password："+password);
    //var url = Uri.parse(API+"/user/login?username="+this.tel+"&password="+this.password);
    var url2 = Uri.parse(API2+"/user/login");

    Map data = {
      'phone': this.tel,
      'password': this.password,
    };

    var body = json.encode(data);
    var response = await http.post(url2, headers: {"Content-Type": "application/json"},body: body);
    print('Response body: ${response.body}');
    var responseJson = json.decode(response.body);
    Map<String, dynamic> PresonMsg = responseJson;
    var code = PresonMsg['code'];
     if(code == 0){
       Fluttertoast.showToast(
           msg: "登录成功",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.blue,
           textColor: Colors.white,
           fontSize: 16.0
       );

       //EasyLoading.showToast('登录成功',toastPosition: EasyLoadingToastPosition.bottom);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLogin", true);
      await prefs.setString("token", PresonMsg['data']);
      await prefs.setString("user", tel);
      Navigator.of(context).pushNamedAndRemoveUntil('/tabs', (Route<dynamic> route) => false);
      // Navigator.of(context).pop();
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context)=>Tabs())
      // );
    }else{
       Fluttertoast.showToast(
           msg: "登录失败，请检查账号密码",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.blue,
           textColor: Colors.white,
           fontSize: 16.0
       );
     }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 150, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '欢迎进入UphOld',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 120,
              width: 20,
            ),
            SizedBox(
              height: 80,
              width: 340,
              child: TextField(
                decoration: InputDecoration(
                    hintText: '请输入手机号',
                    labelText: '手机号',
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
                    prefixIcon: Icon(Icons.person)),
                onChanged: (text) {
                  this.tel =text;
                },
              ),
            ),
            SizedBox(
              width: 340,
              child: TextField(
                textInputAction: TextInputAction.go,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: '请输入密码',
                    labelText: '密码',
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
                    prefixIcon: Icon(Icons.password)),
                onChanged: (text) {
                  this.password =text;
                },
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              width: 320,
              height: 50,
              child: OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ),
                  onPressed: ()  {
                    _login();
                  },
                  child: Text(
                    "登录",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 320,
              height: 50,
              alignment: Alignment.center,
              child: GestureDetector(
                  child: Text("还没有账户，去注册",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Register()));
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
