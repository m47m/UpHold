import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uphold/components/GymCardItem.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  List _list = [];

  ///测试数据集合
  List<TestBean> _testList = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  _getData() {
    //一个JSON格式的字符串
    String jsonStr =
        '[{"title":"健身房名称0","description":"健身房描述健身房描述健身房描述健身房房描述健身房描述健描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
        '{"title":"健身房名称1","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"},'
        '{"title":"健身房名称2","description":"健身房描述健身房描述健身房描述健身房描述健身房描述健房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述健身房描述","isCollect":"1"}]';
    //将JSON字符串转为List
    _list = json.decode(jsonStr);

    for (int i = 0; i < _list.length; i++) {
      _testList.add(new TestBean(
          title: _list[i]["title"],
          description: _list[i]["description"],
          isCollect: _list[i]["isCollect"] == "1" ? true : false));
    }
  }

  ///构建一个列表 ListView
  buildListView() {
    ///懒加载模式构建
    return ListView.builder(
      ///子Item的构建器
      itemBuilder: (BuildContext context, int index) {
        ///每个子Item的布局
        ///在这里是封装到了独立的 StatefulWidget
        // return GardCardItem(
        //   ///子Item对应的数据
        //   bean: _testList[index],
        //   ///可选参数 子Item标识
        //   key: GlobalObjectKey(index),
        // );
        return Container();
      },

      ///ListView子Item的个数
      itemCount: _testList.length,
    );
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
          'Collections',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: this.buildListView(),
    );
  }
}
