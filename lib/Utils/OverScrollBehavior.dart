

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//水波纹去除
class OverScrollBehavior extends ScrollBehavior{

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          //不显示头部水波纹
          showLeading: false,
          //不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
      case TargetPlatform.linux:
        // TODO: Handle this case.
        return child;
        break;
      case TargetPlatform.macOS:
        // TODO: Handle this case.
        return child;
        break;
      case TargetPlatform.windows:
        // TODO: Handle this case.
        return child;
        break;
    }
  }

}

