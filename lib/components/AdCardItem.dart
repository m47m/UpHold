import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Tabs/Home.dart';
import 'package:url_launcher/url_launcher.dart';

class AdBean {
  int? id;
  String? name;
  String? link;
  int? type;
  String? photo;
  int? userId;
  int? click;
  int? view;
  int? cost;
  int? maxCost;

  AdBean(
      {this.id,
        this.name,
        this.link,
        this.type,
        this.photo,
        this.userId,
        this.click,
        this.view,
        this.cost,
        this.maxCost});

  AdBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    type = json['type'];
    photo = json['photo'];
    userId = json['userId'];
    click = json['click'];
    view = json['view'];
    cost = json['cost'];
    maxCost = json['maxCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['link'] = this.link;
    data['type'] = this.type;
    data['photo'] = this.photo;
    data['userId'] = this.userId;
    data['click'] = this.click;
    data['view'] = this.view;
    data['cost'] = this.cost;
    data['maxCost'] = this.maxCost;
    return data;
  }
}

class ADCardItem extends StatefulWidget {
  //final AdBean bean;
  const ADCardItem({Key? key}) : super(key: key);

  @override
  State<ADCardItem> createState() => _ADCardItemState();
}

class _ADCardItemState extends State<ADCardItem> {
  final String API = "http://120.53.102.205";
  String AdTitle = "广告描述";
  String AdLink = "http://120.53.102.205/swagger-ui/index.html#/";
  String ImgURl = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg2020.cnblogs.com%2Fblog%2F1377437%2F202010%2F1377437-20201026115408310-1928859784.png&refer=http%3A%2F%2Fimg2020.cnblogs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1664536236&t=eb37e13ca6e564f7c53955b5d371c59b";
  String token = "1";
  late AdBean bean;

  @override
  void initState() {
    _initOneAd();
    super.initState();
  }

  _initOneAd() async {
    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    if (_token != null) {
      this.token = _token;
    }

    var dio = Dio();

    try {
      var response1 = await dio.get(API + "/ad");
      if (response1.statusCode == 200){
        var AdMsg = json.decode(response1.toString());

        this.bean = AdBean.fromJson(AdMsg['data']);

        setState(() {
          this.ImgURl = API+"/advertiser/ad/"+this.bean.id.toString();
          this.AdTitle = this.bean.name!;
          this.AdLink = this.bean.link!;
        });
      }
    }on DioError catch (e){
      print(e);
      print("Response StatusCode: " + e.response!.statusCode.toString());
    }


  }

  //点击广告
  _AdBack() async {
    var dio = Dio();
    try{
      var response1 = await dio.post(API + "/ad");
    }on DioError catch (e){
      print(e);
      print("Response StatusCode: " + e.response!.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _AdBack();
        launch(this.AdLink);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: buildColumn(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //描述
        Container(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
          width: 230,
          child: Text(
            this.AdTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: Colors.white,
              image: DecorationImage(
                  //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                  //image: AssetImage('images/a.jpg'),
                  image: NetworkImage(this.ImgURl),
                  fit: BoxFit.cover)),
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          height: 120,
        ),
      ],
    );
  }
}
