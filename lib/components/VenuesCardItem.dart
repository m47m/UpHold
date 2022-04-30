import 'package:flutter/material.dart';
import 'package:uphold/pages/Gyms/GymDetails.dart';
import 'package:uphold/pages/Gyms/VenuesDetails.dart';
import 'package:uphold/pages/Reservation.dart';
import 'package:uphold/pages/Tabs/Home.dart';

class VenuesCardItem extends StatelessWidget {
  final VenuesBean bean;
  final GymBean? temp;
  final int AreaIndex;

  VenuesCardItem({required this.bean, required this.temp,required this.AreaIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 160,
      padding: EdgeInsets.all(10),
      child: buildColumn(context),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            this.bean.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                      "    场所描述：${this.bean.description}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      //查看详情
                      Container(
                        width: 90,
                        height: 30,
                        margin: EdgeInsets.fromLTRB(0, 5, 25, 0),
                        child: OutlinedButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VenuesDetails(
                                  title: this.bean.title,
                                  DataBean: this.temp,
                                  AreaIndex: 0,
                                )));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green.shade200)
                          ),
                          child: Text("查看详情",style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      //预约
                      Container(
                        width: 70,
                        height: 30,
                        margin: EdgeInsets.fromLTRB(0, 5, 25, 0),
                        child: OutlinedButton(
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Reservartion(
                                  title: this.temp!.name,
                                  GymId: this.temp!.id.toString(),
                                  introduction: this.temp!.introduction,
                                )));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey.shade400)
                          ),
                          child: Text("预约",style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
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
