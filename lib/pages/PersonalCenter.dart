import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Message.dart';
import 'package:voice/components/PersonalCenter/PersonalInfo.dart';
import 'package:voice/constants/index.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class PersonalCenter extends StatefulWidget {
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  int tips = 0;
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      if (userModel.userid == 0) {
        return;
      }
      var result = await getTips(userid: userModel.userid);
      if (result['noerr'] == 0) {
        setState(() {
          tips = result['data'];
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
        title: Text('我的', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          UserModel userModel = userProvider.userInfo;
          bool _isLogin = userModel.userid != 0;
          return Container(
            width: screenWidth,
            color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                PersonalInfo(isLogin: _isLogin, userModel: userModel),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  color: Colors.white,
                  child: Column(
                    children: normalListWidget(_isLogin),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> normalListWidget(bool isLogin) {
    return personalCenterPagesRoute.map((item) {
      bool isSystemMessage =
          item['title'] == '系统消息' && tips != 0 ? true : false;
      return Builder(builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            if (isLogin) {
              // 跳转到相应页面
              Navigator.of(context).pushNamed(item['page']);
            } else {
              //跳转到登录页面
              Navigator.of(context).pushNamed('login');
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey[100]),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    item['icon'],
                    size: 22,
                    color: item['iconColor'],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    item['title'],
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                isSystemMessage
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400],
                                blurRadius: 6.0,
                              )
                            ]),
                        child: Center(
                          child: Text(
                            tips.toString(),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey[400],
                      ),
              ],
            ),
          ),
        );
      });
    }).toList();
  }
}
