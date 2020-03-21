import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Support.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/components/EnglishCorner/CommentList.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';

class MessageItem extends StatefulWidget {
  final TopicModel content;
  final TabController controller;
  final int index;
  MessageItem({Key key, this.content, this.controller, this.index})
      : super(key: key);
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  // 标签页跳转
  Function jumpTopicPage(List<String> topics) {
    int index = topics.indexOf(widget.content.topicType);
    return () {
      widget.controller.index = index;
    };
  }

  // 跳转到详情页
  void showCommentPage() {
    print('评论');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommentList(
            topicModel: widget.content,
          );
        });
  }

  // 点赞
  Future<void> supportHandler() async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      TopicProvider topicProvider =
          Provider.of<TopicProvider>(context, listen: false);
      if (userModel.userid == 0) {
        Navigator.of(context).pushNamed('login');
        return;
      }
      var result = await support(
        userid: userModel.userid,
        targetId: widget.content.topicid,
        type: 1,
      );
      if (result['noerr'] == 0) {
        topicProvider.updateSupport(
          widget.content.topicType,
          widget.content.topicid,
          result['data'],
        );
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  imageUrl: widget.content.userImage,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.content.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.content.createTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            width: screenWidth,
            margin: EdgeInsets.only(left: 40, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.content.topicContent.text,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                imageLayout(screenWidth)
              ],
            ),
          ),
          tagLayout(),
          commentAndSupport()
        ],
      ),
    );
  }

  /// 图片布局
  Widget imageLayout(double screenWidth) {
    List<String> images = widget.content.topicContent.images;
    double width;
    if (images.length == 1) {
      width = (screenWidth / 2).floorToDouble() - 50;
    } else if (images.length <= 4) {
      width = (screenWidth / 2).floorToDouble() - 50;
    } else {
      width = (screenWidth / 3).floorToDouble() - 50;
    }
    List<Widget> imageWidgets = images.map((url) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: width,
            height: width,
            fit: BoxFit.cover,
            imageUrl: url,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ));
    }).toList();

    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        children: imageWidgets,
      ),
    );
  }

  Widget tagLayout() {
    return Consumer<TopicProvider>(
      builder: (context, topicProvider, child) {
        List<String> tabs = topicProvider.topicTitle;
        return Container(
          margin: EdgeInsets.only(left: 40, top: 10),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: GestureDetector(
            onTap: jumpTopicPage(tabs),
            child: Text(
              '#' + widget.content.topicType,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF5B86E5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget commentAndSupport() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: showCommentPage,
                child: Icon(
                  Icons.chat,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  widget.content.comment.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: supportHandler,
                child: Icon(
                  Icons.thumb_up,
                  size: 20,
                  color: widget.content.support.action
                      ? Color(0xFF5B86E5)
                      : Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  widget.content.support.count.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
