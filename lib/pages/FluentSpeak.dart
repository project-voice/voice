import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:voice/store/action/action.dart';

import 'package:voice/api/User.dart';
import 'package:toast/toast.dart';

class FluentSpeak extends StatefulWidget {
  _FluentSpeakState createState() => _FluentSpeakState();
}

class _FluentSpeakState extends State<FluentSpeak> {
  List<Widget> list = [];
  @override
  void initState() {
    super.initState();
    requestData();
  }

  Future<void> requestData() async {
    try {
      var data = await getUser();
      var temp = data.map<Widget>((item) {
        return Text(item['id'].toString() + item['title']);
      }).toList();
      Toast.show('加载成功', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      setState(() {
        list = temp;
      });
    } catch (err) {
      print(err);
      Toast.show('网络请求失败', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: list.toList(),
          );
  }
}
