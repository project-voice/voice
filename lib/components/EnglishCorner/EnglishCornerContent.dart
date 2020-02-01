import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:voice/components/common/Refresh.dart';
import 'package:voice/components/EnglishCorner/MessageItem.dart';

class EnglishCornerContent extends StatefulWidget {
  final List topicContent;
  EnglishCornerContent({Key key, this.topicContent}) : super(key: key);

  _EnglishCornerContentState createState() => _EnglishCornerContentState();
}

class _EnglishCornerContentState extends State<EnglishCornerContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Refresh(
            onLoadCallback: (EasyRefreshController controller) {
              return Future.delayed(Duration(seconds: 2)).then((value) {
                controller.finishLoad(success: true);
                setState(() {
                  // test.add(Text('124'));
                });
              }).catchError((err) {
                controller.finishLoad(success: false);
              });
            },
            onRefreshCallback: (EasyRefreshController controller) {
              return Future.delayed(Duration(seconds: 2)).then((value) {
                controller.finishRefresh(success: true);
                setState(() {
                  // test.add(Text('124'));
                });
              }).catchError((err) {
                controller.finishRefresh(success: false);
              });
            },
            child: ListView.separated(
                itemCount: widget.topicContent.length,
                itemBuilder: (BuildContext context, int index) {
                  Map content = widget.topicContent[index];
                  return MessageItem(content: content);
                },
                separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Divider(height: .0)))));
  }
}
