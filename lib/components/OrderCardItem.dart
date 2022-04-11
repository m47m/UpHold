import 'package:flutter/material.dart';
import 'package:uphold/pages/Tabs/MyOrder.dart';

class OrderCardItem extends StatelessWidget {
  ///本Item对应的数据模型
  final OrderBean bean;

  const OrderCardItem({required this.bean,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      height: 180,
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${this.bean.period}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),

                  // Text(
                  //   "${this.bean.status}",
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  // ),
                 _getOrderStatus(int.parse(this.bean.status))
                ],
              ),
              margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            ),

            Divider(
              height: 1.5,
              thickness: 1.3,
            ),

            Container(
              height: 30,

              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                  "${this.bean.title}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              height: 50,

              margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Text(
                "${this.bean.description}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getOrderStatus(int status){
    Widget?  widgetofStatus;
    switch(status){
      case 1:
       widgetofStatus = Text(
         "已完成",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
       );
        break;
      case 2:
        widgetofStatus = Text(
          "未签到",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.lightGreen),
        );
        break;
      case 3:
        widgetofStatus = Text(
          "未签退",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.redAccent),
        );
        break;
    }
    return widgetofStatus;
  }
}
