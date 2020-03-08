import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/components/Video/CommentList.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/model/VideoModel.dart';
import 'dart:math' as math;

import 'package:voice/provider/UserProvider.dart';
import 'package:voice/provider/VideoProvider.dart';

class VideoSideBarInfo extends StatelessWidget {
  final VideoModel videoInfoData;
  final String type;
  final int index;
  VideoSideBarInfo({this.videoInfoData, this.index, this.type});

  Function followHandler(BuildContext context, int followid) {
    return () async {
      try {
        UserModel userModel = Provider.of<UserProvider>(
          context,
          listen: false,
        ).userInfo;
        VideoProvider videoProvider = Provider.of<VideoProvider>(
          context,
          listen: false,
        );
        if (userModel.userid == 0) {
          // 跳转到登录
          Navigator.of(context).pushNamed('login');
        } else {
          var result = await actionFollow(
            userid: userModel.userid,
            followid: followid,
          );
          if (result['noerr'] == 0) {
            videoProvider.updateFollow(followid);
          }
          Toast.show(
            result['message'],
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
          );
        }
      } catch (err) {
        print(err);
      }
    };
  }

  Function supportHandler(BuildContext context, int videoid) {
    return () async {
      try {
        UserModel userModel =
            Provider.of<UserProvider>(context, listen: false).userInfo;
        VideoProvider videoProvider =
            Provider.of<VideoProvider>(context, listen: false);
        if (userModel.userid == 0) {
          // 跳转到登录
          Navigator.of(context).pushNamed('login');
          return;
        }
        var result =
            await actionSupport(userid: userModel.userid, videoid: videoid);
        if (result['noerr'] == 0) {
          videoProvider.updateSupport(type, index, result['data']);
        } else {
          print(result['message']);
        }
      } catch (err) {
        print(err);
      }
    };
  }

  Function shareHandler(BuildContext context, int videoid) {
    return () async {
      try {
        Share.share(videoInfoData.videoDescription,
            subject: videoInfoData.videoDescription);
        VideoProvider videoProvider =
            Provider.of<VideoProvider>(context, listen: false);
        var result = await actionShare(videoid: videoid);
        if (result['noerr'] == 0) {
          videoProvider.updateShare(type, index, videoInfoData.videoShare + 1);
        } else {
          print(result['message']);
        }
      } catch (err) {
        print(err);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight / 2 - 60,
      right: 0,
      child: Container(
        width: 80,
        height: screenHeight / 2,
        padding: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            imageWidget(),
            supportWidget(),
            commentWidget(),
            shareWidget(),
          ],
        ),
      ),
    );
  }

  // 头像
  Widget imageWidget() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          height: 60,
          child: Stack(
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: videoInfoData.userImage,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 14,
                child: videoInfoData.follow
                    ? Container()
                    : GestureDetector(
                        onTap: followHandler(context, videoInfoData.userid),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black54, blurRadius: 8.0)
                              ]),
                          child: Center(
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  // 点赞组件
  Widget supportWidget() {
    Support support = videoInfoData.support;
    return Builder(
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: supportHandler(context, videoInfoData.videoid),
                  child: Icon(
                    Icons.favorite,
                    color: support.action ? Colors.red : Colors.white,
                    size: 40,
                  )),
              Text(support.count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ))
            ],
          ),
        );
      },
    );
  }

  // 分享组件
  Widget shareWidget() {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(right: 5),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: shareHandler(context, videoInfoData.videoid),
              child: Transform(
                transform: Matrix4.identity()..rotateY(math.pi),
                origin: Offset(20, 0),
                child: Icon(
                  Icons.reply,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            Text(videoInfoData.videoShare.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ))
          ],
        ),
      );
    });
  }

  // 评论组件
  Widget commentWidget() {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(right: 5),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('评论');
                // 弹出评论列表
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return CommentList(
                        videoData: videoInfoData,
                        type: type,
                        index: index,
                      );
                    });
              },
              child: Icon(
                Icons.comment,
                color: Colors.white,
                size: 40,
              ),
            ),
            Text(videoInfoData.comment.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ))
          ],
        ),
      );
    });
  }
}
