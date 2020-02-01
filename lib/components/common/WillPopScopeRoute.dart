// 导航栏返回拦截组件
import 'package:flutter/material.dart';

class WillPopScopeRoute extends StatefulWidget {
  final Widget child;
  WillPopScopeRoute({Key key, this.child}) : super(key: key);
  _WillPopScopeRouteState createState() => _WillPopScopeRouteState();
}

class _WillPopScopeRouteState extends State<WillPopScopeRoute> {
  DateTime _lastTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: () async {
        if (_lastTime == null ||
            DateTime.now().difference(_lastTime) > Duration(seconds: 1)) {
          _lastTime = DateTime.now();
          return false;
        }
        return true;
      },
    );
  }
}
