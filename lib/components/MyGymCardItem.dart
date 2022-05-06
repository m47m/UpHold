import 'package:flutter/material.dart';
import 'package:uphold/pages/Gyms/GymDetails.dart';
import 'package:uphold/pages/Reservation.dart';
import 'package:uphold/pages/Tabs/Home.dart';
import 'package:uphold/pages/Tabs/MyGym.dart';

///ListView 的子Item
class MyGymCardItem extends StatefulWidget {
  ///本Item对应的数据模型

  GymBean temp;

  MyGymCardItem({required this.temp,Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState();
  }
}

class _ListItemState extends State<MyGymCardItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GymDetails(
              title: widget.temp.name,
              DataBean: widget.temp,
              //title: widget.bean.title,
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
          child: Text(
            "${widget.temp.name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                  //健身房描述
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    width: 245,
                    height: 70,
                    child: Text(
                      "${widget.temp.introduction}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  //按钮
                  Container(
                    width: 70,
                    height: 30,
                    margin: EdgeInsets.fromLTRB(0, 5, 25, 0),
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Reservartion(
                              title: widget.temp.name,
                              GymId: widget.temp.id.toString(),
                              introduction: widget.temp.introduction,
                            )));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.grey.shade400)
                      ),
                      child: Text("预约",style: TextStyle(color: Colors.white)),
                    ),

                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

