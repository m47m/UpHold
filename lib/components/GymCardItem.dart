import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uphold/pages/Gyms/GymDetails.dart';
import 'package:uphold/pages/Tabs/Home.dart';

///ListView 的子Item
class GardCardItem extends StatefulWidget {
  ///本Item对应的数据模型
  final TestBean bean;
  final GymBean temp;

  GardCardItem({required this.bean, required this.temp, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<GardCardItem> {
  String API = "http://120.53.102.205";
  NetworkImage _networkImage = new NetworkImage("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg2020.cnblogs.com%2Fblog%2F1377437%2F202010%2F1377437-20201026115408310-1928859784.png&refer=http%3A%2F%2Fimg2020.cnblogs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1664536236&t=eb37e13ca6e564f7c53955b5d371c59b");

  @override
  void initState() {
    // TODO: implement initState
    this.getGymImg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GymDetails(
                  title: widget.bean.title,
                  DataBean: widget.temp,
                  imgUrl: this._networkImage.url,
                )));
      },
      child: Container(
        width: 320,
        height: 160,
        padding: EdgeInsets.all(10),
        child: buildColumn(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 320,
          child: Text(
            "${widget.bean.title}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //图片
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.lightBlueAccent,
                    image: DecorationImage(
                        //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                        //image: AssetImage('images/a.jpg'),
                        //image: NetworkImage("${widget.bean.imgURL}"),
                        image: this._networkImage,
                        fit: BoxFit.cover)),
                width: 130,
                height: 100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //描述
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    width: 230,
                    height: 70,
                    child: Text(
                      "  描述：${widget.bean.description}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  //收藏
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        _collect();
                        setState(() {});
                      },
                      icon: Icon(widget.bean.isCollect
                          ? Icons.favorite
                          : Icons.favorite_border),
                      color: Colors.blue,
                      // Icons.favorite_border
                    ),

                    // OutlinedButton(
                    //   ///按钮的背景
                    //   //color: widget.bean.isCollect ? Colors.blue : Colors.grey[200],
                    //   ///点击更新当前 Item 数据以及刷新页面显示
                    //   onPressed: () {
                    //     setState(() {
                    //       widget.bean.isCollect = !widget.bean.isCollect;
                    //     });
                    //   },
                    //   child: Text(
                    //     "${widget.bean.isCollect ? '已收藏' : '收藏'}",
                    //     style: TextStyle(
                    //         color: widget.bean.isCollect
                    //             ? Colors.white
                    //             : Colors.red),
                    //   ),
                    // ),
                    width: 70,
                    height: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _collect() async {
    var dio = Dio();

    final prefs = await SharedPreferences.getInstance();
    String? _token = prefs.getString("token");
    Response response;
    String ToastMsg;
    if (widget.bean.isCollect) {
      //取消收藏
      response =
          await dio.post(API + "/user/collect?id=" + widget.temp.id.toString(),
              options: Options(headers: {
                "Auth": _token,
              }));

      ToastMsg = "取消成功";
    } else {
      //收藏
      response =
          await dio.get(API + "/user/collect?id=" + widget.temp.id.toString(),
              options: Options(headers: {
                "Auth": _token,
              }));
      ToastMsg = "收藏成功";
    }

    if (response.statusCode == 200) {
      var CollectMsg = json.decode(response.toString());
      var code = CollectMsg['code'];

      if (code == 0) {
        setState(() {
          widget.bean.isCollect = !widget.bean.isCollect;
        });

        EasyLoading.showToast(ToastMsg,
            toastPosition: EasyLoadingToastPosition.bottom);
      }
    }
  }

  ///内容区域
  Row buildRow() {
    ///左右线性排开
    return Row(
      children: [
        ///权重布局 文本占用空白区域
        Expanded(
            child: Text(
          "${widget.bean.title}",
        )),

        ///收藏按钮
        OutlinedButton(
          ///按钮的背景
          //color: widget.bean.isCollect ? Colors.blue : Colors.grey[200],
          ///点击更新当前 Item 数据以及刷新页面显示
          onPressed: () {
            print('dawd');
            _collect();
            setState(() {
              //widget.bean.isCollect = !widget.bean.isCollect;
            });
          },
          child: Text(
            "${widget.bean.isCollect ? '已收藏' : '收藏'}",
            style: TextStyle(
                color: widget.bean.isCollect ? Colors.white : Colors.red),
          ),
        ),
      ],
    );
  }

  //图片
  getGymImg() async {
    var dio = Dio();
    try {
      var response1 = await dio.get(widget.bean.imgURL);
      this._networkImage = NetworkImage(widget.bean.imgURL);
      setState(() {

      });
    } on DioError catch (e) {
      print("Response StatusCode: " + e.response!.statusCode.toString());
    }
  }
}
