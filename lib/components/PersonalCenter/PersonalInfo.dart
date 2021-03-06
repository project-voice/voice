import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/routes/Application.dart';
import 'package:voice/routes/Routes.dart';

class PersonalInfo extends StatelessWidget {
  final bool isLogin;
  final UserModel userModel;
  PersonalInfo({Key key, this.isLogin, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!isLogin) {
          Application.router.navigateTo(
            context,
            Routes.loginPage,
            transition: TransitionType.native,
          );
        }
      },
      child: Container(
        width: screenWidth,
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ClipOval(
                child: isLogin
                    ? CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl: userModel.userImage,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Image.asset(
                        'assets/images/person-head.jpeg',
                        width: 50,
                        height: 50,
                      ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  isLogin ? userModel.userName : '注册/登录',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: isLogin
                  ? Container()
                  : Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey[400],
                      size: 40,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
