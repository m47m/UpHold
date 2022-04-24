import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

import 'package:flutter_verification_box/verification_box.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isButtonEnable = true; //按钮状态  是否可点击
  String buttonText = '发送验证码'; //初始文本
  int count = 60; //初始倒计时时间
  Timer? timer; //倒计时的计时器
  TextEditingController mController = TextEditingController();

  String tel = "";
  String password = "";
  String password2 = "";
  String code = "";
  String API = "http://api.uphold.tongtu.xyz";

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          buttonText = '发送验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        //当按钮可点击时
        isButtonEnable = false; //按钮状态标记
        _initTimer();
        return null; //返回null按钮禁止点击
      } else {
        //当按钮不可点击时
//        debugPrint('false');
        return null; //返回null按钮禁止点击
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    mController.dispose();
    super.dispose();
  }

  _register() async {
    print("注册信息：tel："+tel+"password："+password+"code："+ this.code);
    //var url = Uri.parse(API+"/user/login?username="+this.tel+"&password="+this.password);
    var url = Uri.parse(API+"/user/register");

    Map data = {
      'phone': this.tel,
      'password': this.password,
      'code':this.code,
    };
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json"},body: body);
    print('Response body: ${response.body}');
    var responseJson = json.decode(response.body);

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
              '欢迎来到UphOld',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),

            SizedBox(
              height: 80,
              width: 20,
            ),

            //手机号
            SizedBox(
              height: 60,
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
                  this.tel = text;
                },
              ),
            ),

            //密码
            SizedBox(
              height: 60,
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
                  this.password = text;
                },
              ),
            ),

            //确认密码
            SizedBox(
              height: 60,
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
                    prefixIcon: Icon(Icons.password_rounded)),
                onChanged: (text) {
                  this.password2 = text;
                },
              ),
            ),
            //验证码

            SizedBox(
                height: 60,
                width: 340,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        // obscureText: true,
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
                            prefixIcon: Icon(Icons.domain_verification)),
                        onChanged: (text) {
                          this.code = text;
                        },
                      ),
                    ),

              
                    Container(
                      width: 120,
                      height: 40,
                      child: OutlinedButton(
                          style: ButtonStyle(
                            // backgroundColor: MaterialStateProperty.all(Colors.blue.shade100),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _buttonClickListen();
                            });
                          },
                          child: Text(
                            '$buttonText',
                            style: TextStyle(
                              color: Colors.black,
                                fontWeight: FontWeight.w400, fontSize: 13),
                          )),
                    ),

//                     Container(
//                       width: 80,
//
//
//
//                       child: FlatButton(
//                         disabledColor: Colors.grey.withOpacity(0.1),
//                         //按钮禁用时的颜色
//                         disabledTextColor: Colors.white,
//                         //按钮禁用时的文本颜色
//                         textColor: isButtonEnable
//                             ? Colors.white
//                             : Colors.black.withOpacity(0.2),
//                         //文本颜色
//                         color: isButtonEnable
//                             ? Color(0xff44c5fe)
//                             : Colors.grey.withOpacity(0.1),
//                         //按钮的颜色
//                         splashColor: isButtonEnable
//                             ? Colors.white.withOpacity(0.1)
//                             : Colors.transparent,
//
//                         shape: StadiumBorder(side: BorderSide.none),
//                         onPressed: () {
//                           setState(() {
//                             _buttonClickListen();
//                           });
//                         },
// //                        child: Text('重新发送 (${secondSy})'),
//                         child: Text(
//                           '$buttonText',
//                           style: TextStyle(
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//
//                     ),
                  ],
                )),

            SizedBox(
              height: 60,
            ),

            Container(
              width: 320,
              height: 50,
              child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade300),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _register();
                  },
                  child: Text(
                    "注册",
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
                  child: Text(
                    "已有帐号，去登陆",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
