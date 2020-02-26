import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/components/PersonalCenter/Setup/Birthday.dart';
import 'package:voice/components/PersonalCenter/Setup/Description.dart';
import 'package:voice/components/PersonalCenter/Setup/Email.dart';
import 'package:voice/components/PersonalCenter/Setup/HeadImage.dart';
import 'package:voice/components/PersonalCenter/Setup/Logout.dart';
import 'package:voice/components/PersonalCenter/Setup/Name.dart';
import 'package:voice/components/PersonalCenter/Setup/Password.dart';
import 'package:voice/components/PersonalCenter/Setup/Sex.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          UserModel userModel = userProvider.userInfo;
          return userModel.userid == 0
              ? Container()
              : Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        HeaderImage(userModel: userModel),
                        Name(userModel: userModel),
                        Email(userModel: userModel),
                        Password(userModel: userModel),
                        Sex(userModel: userModel),
                        Birthday(userModel: userModel),
                        Description(userModel: userModel),
                        Logout(),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
