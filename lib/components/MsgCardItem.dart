import 'package:flutter/material.dart';
import 'package:uphold/pages/Persons/Message.dart';
import 'package:uphold/pages/Persons/MsgDetails.dart';

class MsgCardItem extends StatefulWidget {

  MsgBean bean;
  MsgCardItem({required this.bean ,Key? key}) : super(key: key);

  @override
  _MsgCardItemState createState() => _MsgCardItemState();
}

class _MsgCardItemState extends State<MsgCardItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MsgDetails(bean: this.widget.bean,)));
      },
      child: this._buildColumn()
    );
  }

  _buildColumn(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 1, 15, 0),
      height: 128,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.bean.title}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
          Text('${widget.bean.from}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),maxLines: 1,overflow: TextOverflow.ellipsis,),
          Text('${widget.bean.description}'
              ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),maxLines: 3,overflow: TextOverflow.ellipsis,),
          // Divider(
          //   thickness: 1,
          // )
          // Container(
          //   margin: EdgeInsets.all(5),
          //   height: 60,
          //   color: Colors.blue,
          // )
        ],
      ),
    );
  }
}
