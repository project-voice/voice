import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class BaseInfo extends StatelessWidget {
  final String baseInfo;
  BaseInfo({Key key, this.baseInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        UserModel userModel = userProvider.userInfo;
        return Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userModel.userName,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  userModel.userDescription,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
