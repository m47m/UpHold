import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(
            "$value",
            style: TextStyle(fontSize: 18),
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

  List<String> _ballList = [];

  @override
  void initState() {
    super.initState();
    _ballList = ["篮球", "足球", "排球", "冰球", "水球"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        //清除title左右padding，默认情况下会有一定的padding距离
        toolbarHeight: 55,
        //将高度定到44，设计稿的高度。为了方便适配，
        //推荐使用插件flutter_screenutil做屏幕的适配工作
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        //由于title本身是接受一个widget，所以可以直接给他一个自定义的widget。
        title: new Text(
          'INFO',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: DirectSelectContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text("选择日期：",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ),
              Padding(
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
                                  values: _ballList,
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
                                  onItemSelectedListener:
                                      (item, index, context) {
//                                setState(() {
//                                  selectedFoodVariants = index;
//                                });
                                    print(item);
                                  }),
                              padding: EdgeInsets.only(left: 22))),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: _getDropdownIcon(),
                      )
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
