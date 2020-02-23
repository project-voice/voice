import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/User.dart';
import 'package:voice/components/PersonalCenter/UserItem.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class FollowList extends StatefulWidget {
  _FollowListState createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  List<UserModel> followList = [];
  @override
  void initState() {
    super.initState();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      var result = await getFollowList(userid: userModel.userid);
      if (result['noerr'] == 0) {
        setState(() {
          followList = result['data']
              .map((user) {
                return UserModel.fromJson(user);
              })
              .cast<UserModel>()
              .toList();
        });
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('我关注的'),
        centerTitle: true,
      ),
      body: followList.length == 0
          ? Center(
              child: Text(
                '您还未关注任何人',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          : Container(
              width: screenWidth,
              padding: EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.grey[200],
                    child: Text(
                      '正在关注${followList.length}人',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                        itemCount: followList.length,
                        itemBuilder: (context, index) {
                          return UserItem(
                            userModel: followList[index],
                            refreshCallback: fetchRequest,
                          );
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
