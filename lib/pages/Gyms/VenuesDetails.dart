import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uphold/components/EquipmentItem.dart';
import 'package:uphold/components/PhotoViewSimpleScreen.dart';
import 'package:uphold/pages/Reservation.dart';
import 'package:carousel_slider/carousel_slider.dart';


class EquipmentBean {
  String title;
  String description;
  List<String> imgList;

  EquipmentBean({
    required this.title,
    required this.description,
    required this.imgList,
  });
}

class VenuesDetails extends StatefulWidget {
  String title = " ";

  VenuesDetails({required this.title, Key? key}) : super(key: key);

  @override
  _VenuesDetailsState createState() => _VenuesDetailsState(this.title);
}

class _VenuesDetailsState extends State<VenuesDetails> {
  String title = " ";

  _VenuesDetailsState(this.title) {}

  List _list = [];

  ///测试数据集合
  List<EquipmentBean> _testList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    //一个JSON格式的字符串
    String jsonStr =
        '[{"title":"设备名称0","description":"设备描述设备描述设备描设备描述设备描述设备描述设备描述设备描描述设备描述设备描述设备描述","isCollect":"1"},'
        '{"title":"设备名称0","description":"设备描述设备描述设备描述设备描述设备描述设备描述设备描述设备描述","isCollect":"0"}]';
    //将JSON字符串转为List
    _list = json.decode(jsonStr);
    for (int i = 0; i < _list.length; i++) {
      _testList.add(new EquipmentBean(
          title: _list[i]["title"], description: _list[i]["description"],
          imgList: [ 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
        'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80']));
    }
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
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        centerTitle: true,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        title: new Text(
          'VenuesDetails',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: this.buildListView(),
    );
  }

  buildListView() {
    ///懒加载模式构建
    return ListView.builder(
      itemCount: _getItemListCount(),
      itemBuilder: (BuildContext context, int index) {
        return buildItemWidget(context, index);
      },
    );
  }
  // 总count数
  int _getItemListCount() {
    return this._testList.length + 1;
  }

  buildItemWidget(BuildContext context, int index) {
    if (index < 1) {
      return _buildHeaderWidget(context, index);
    } else {
      int itemIndex = index - 1;
      return _itemBuildWidget(context, itemIndex);
    }
  }

  Widget _itemBuildWidget(BuildContext context, int index) {
    return new Container(
      child: EquipmentItem(
        ///子Item对应的数据
        bean: _testList[index],
        ///可选参数 子Item标识
        //key: GlobalObjectKey(index),
      ),
    );
  }

  // header内容
  Widget _buildHeaderWidget(BuildContext context, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PhotoViewSimpleScreen(
                    heroTag: 'simple',
                    imageProvider: NetworkImage("https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80"),

                  )));
            },
            child:  Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  color: Colors.blue,
                  image: DecorationImage(
                    //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                      image: NetworkImage("https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80"),
                      fit: BoxFit.cover)),
              height: 180,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              this.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              "联系电话：" + "18731870785",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              "场所描述场所描述场所描述场所描述场所描述场所描述场所描述场所描述场所描述场所描述",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              "健身房地理位置健身房地理位置健身房地理位置",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Reservartion(
                              title: ' ',
                            )));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade300)),
                      child: Text("预约", style: TextStyle(color: Colors.white))),
                )
              ],
            ),
          ),
          Divider(thickness: 2, indent: 10, endIndent: 10),
        ],
      ),
    );
  }
}
