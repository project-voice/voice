import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class UserItem extends StatelessWidget {
  final UserModel userModel;
  final Function refreshCallback;
  UserItem({Key key, this.userModel, this.refreshCallback}) : super(key: key);

  Function cancelFollowCallabck(BuildContext context) {
    return () async {
      try {
        UserModel userModelInfo = Provider.of<UserProvider>(
          context,
          listen: false,
        ).userInfo;
        var result = await cancelFollow(
          userid: userModelInfo.userid,
          followid: userModel.userid,
        );
        if (result['noerr'] == 0) {
          Future.delayed(Duration(seconds: 2)).then((value) {
            refreshCallback();
          });
        }
        Toast.show(
          result['message'],
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      } catch (err) {
        print(err);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipOval(
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: userModel.userImage,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Text(
                userModel.userName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: cancelFollowCallabck(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '取消关注',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
