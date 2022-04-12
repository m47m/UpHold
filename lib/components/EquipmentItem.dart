import 'package:flutter/material.dart';
import 'package:uphold/pages/Gyms/VenuesDetails.dart';

class EquipmentItem extends StatefulWidget {
  final EquipmentBean bean;

   EquipmentItem({required this.bean, Key? key}) : super(key: key);

  @override
  _EquipmentItemState createState() => _EquipmentItemState();
}

class _EquipmentItemState extends State<EquipmentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Container(
        width: 360,
        padding: EdgeInsets.all(10),
        child: buildColumn(),
      ) ,
    );
  }

  buildColumn(){
    return Column(
      children: [
        Container(
          child: Text(widget.bean.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
        ),
        Container(
          width: 360,
          child: Text(widget.bean.description),
        ),
        Container(
          width: 300,
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.blue,
              image: DecorationImage(
                //FileImage 本地图片   、NetworkImage 网络  、AssetImage资源
                  image: AssetImage('images/a.jpg'), fit: BoxFit.cover)),
        )
      ],
    );
  }
}
