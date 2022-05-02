import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CodeDialog extends Dialog {
  String CodeData = "123";

  CodeDialog({Key? key, required this.CodeData});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Stack(children: [
              Center(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Text('签到or签退', style: TextStyle(fontSize: 16.0)),
                            QrImage(
                              data: CodeData,
                              version: QrVersions.auto,
                              size: 200.0,
                            )
                          ])
                      )
                  )
              )
            ])));
  }


}
