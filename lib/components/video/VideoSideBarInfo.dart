import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share/share.dart';
import 'package:voice/common/fonts/icons.dart';

class VideoSideBarInfo extends StatelessWidget {
  final vedioInfoData;
  VideoSideBarInfo({this.vedioInfoData});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
        top: screenHeight / 2 + 50,
        right: 0,
        child: Container(
            width: 80,
            height: screenHeight / 2,
            padding: EdgeInsets.only(right: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        print('跳转到个人主页');
                      },
                      child: ClipOval(
                          child: Image.network(
                        vedioInfoData['imgUrl'],
                        width: 50,
                      ))),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                if (vedioInfoData['isAction']) {
                                  print('已赞');
                                  return;
                                }
                                print('点赞');
                              },
                              child: Icon(
                                CustomIcons.heart,
                                color: vedioInfoData['isAction']
                                    ? Colors.red
                                    : Colors.white,
                                size: 40,
                              )),
                          Text(vedioInfoData['count'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(right: 5),
                      child: GestureDetector(
                          onTap: () {
                            print('分享');
                            Share.share(vedioInfoData['description'],
                                subject: vedioInfoData['description']);
                          },
                          child: Transform(
                              transform: Matrix4.identity()..rotateY(math.pi),
                              origin: Offset(20, 0),
                              child: Icon(
                                Icons.reply,
                                color: Colors.white,
                                size: 40,
                              ))))
                ])));
  }
}
