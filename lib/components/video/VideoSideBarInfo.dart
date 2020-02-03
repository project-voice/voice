import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'dart:math' as math;

import 'package:voice/store/action/action.dart';

class VideoSideBarInfo extends StatelessWidget {
  final vedioInfoData;
  VideoSideBarInfo({this.vedioInfoData});
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    Map support = vedioInfoData['support'];
    return Positioned(
        top: screenHeight / 2 + 50,
        right: 0,
        child: Container(
            width: 80,
            height: screenHeight / 2,
            padding: EdgeInsets.only(right: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
                    Widget>[
              GestureDetector(
                  onTap: () {
                    print('跳转到个人主页');
                  },
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: vedioInfoData['imgUrl'],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      StoreConnector(converter: (store) {
                        return (data) => store.dispatch(createActionHandler(
                            ActionTypes.VideoSupport, data));
                      }, builder: (context, actionSupport) {
                        return GestureDetector(
                            onTap: () {
                              if (support['action']) {
                                print('已赞');
                                return;
                              }
                              // TODO：调点赞接口
                              actionSupport(vedioInfoData['id']);
                              print('点赞');
                            },
                            child: Icon(
                              Icons.favorite,
                              color:
                                  support['action'] ? Colors.red : Colors.white,
                              size: 40,
                            ));
                      }),
                      Text(support['count'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ))
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    children: <Widget>[
                      StoreConnector(converter: (store) {
                        return (data) => store.dispatch(
                            createActionHandler(ActionTypes.VideoShare, data));
                      }, builder: (context, actionShare) {
                        return GestureDetector(
                            onTap: () {
                              print('分享');
                              Share.share(vedioInfoData['description'],
                                  subject: vedioInfoData['description']);
                              actionShare(vedioInfoData['id']);
                            },
                            child: Transform(
                                transform: Matrix4.identity()..rotateY(math.pi),
                                origin: Offset(20, 0),
                                child: Icon(
                                  Icons.reply,
                                  color: Colors.white,
                                  size: 40,
                                )));
                      }),
                      Text(vedioInfoData['share'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ))
                    ],
                  ))
            ])));
  }
}
