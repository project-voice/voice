import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:voice/components/common/Refresh.dart';

class EnglishCornerContent extends StatefulWidget {
  _EnglishCornerContentState createState() => _EnglishCornerContentState();
}

class _EnglishCornerContentState extends State<EnglishCornerContent> {
  var test = [Text('134')];
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        child: Refresh(
            onLoadCallback: (EasyRefreshController controller) {
              return Future.delayed(Duration(seconds: 2)).then((value) {
                controller.finishLoad(success: true);
              }).catchError((err) {
                controller.finishLoad(success: false);
              });
            },
            onRefreshCallback: (EasyRefreshController controller) {
              return Future.delayed(Duration(seconds: 2)).then((value) {
                controller.finishRefresh(success: true);
                setState(() {
                  test.add(Text('124'));
                });
              }).catchError((err) {
                controller.finishRefresh(success: false);
              });
            },
            child: ListView.builder(
              itemCount: test.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(index.toString());
              },
            )));
  }
}
