import 'package:flutter/material.dart';
import 'package:voice/components/PersonalCenter/PersonalInfo.dart';
import 'package:voice/constants/index.dart';

class PersonalCenter extends StatefulWidget {
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('我的', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          width: screenWidth,
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              PersonalInfo(isLogin: false, personalData: {}),
              Container(
                  margin: EdgeInsets.only(top: 12),
                  color: Colors.white,
                  child: Column(
                    children: normalListWidget(false),
                  ))
            ],
          ),
        ));
  }

  List<Widget> normalListWidget(bool isLogin) {
    return personalCenterPagesRoute.map((item) {
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
                        bottom: BorderSide(width: 1, color: Colors.grey[100]))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Icon(item['icon'],
                            size: 22, color: item['iconColor'])),
                    Expanded(
                        flex: 5,
                        child: Text(item['title'],
                            style: TextStyle(fontSize: 16))),
                    Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[400],
                        )),
                  ],
                )));
      });
    }).toList();
  }
}
