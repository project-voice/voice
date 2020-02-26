import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/provider/UserProvider.dart';

class Logout extends StatelessWidget {
  @override
  Function logoutHandler(BuildContext context) {
    return () async {
      await Provider.of<UserProvider>(context, listen: false).logout();
      Navigator.of(context).pop();
    };
    // 退出登录
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logoutHandler(context),
      child: Container(
        height: 60,
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Center(
          child: Text(
            '退出登录',
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
