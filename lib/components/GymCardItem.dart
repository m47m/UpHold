import 'package:flutter/material.dart';
import 'package:uphold/pages/Gyms/GymDetails.dart';
import 'package:uphold/pages/Tabs/Home.dart';

///ListView 的子Item
class GardCardItem extends StatefulWidget {
  ///本Item对应的数据模型
   final TestBean bean;
  final GymBean temp;


  GardCardItem({required this.bean,  required this.temp,  Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<GardCardItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GymDetails(
              title: widget.bean.title,
              DataBean: widget.temp,
            )));
      },
      child: Container(
        width: 320,
        height: 160,
        padding: EdgeInsets.all(10),
        child: buildColumn(),
      ) ,
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
                  color: Colors.blue,
                  image: DecorationImage(
                    //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                      image: AssetImage('images/a.jpg'), fit: BoxFit.cover)),
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
                          setState(() {
                            widget.bean.isCollect = !widget.bean.isCollect;
                          });
                    },
                    icon: Icon(widget.bean.isCollect ? Icons.favorite:Icons.favorite_border),
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
          setState(() {
            widget.bean.isCollect = !widget.bean.isCollect;
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
}}
