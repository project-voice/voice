import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Support.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/components/EnglishCorner/CommentList.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';

class TopicItem extends StatefulWidget {
  final TopicModel topicModel;
  final Function refreshCallback;
  TopicItem({
    Key key,
    this.topicModel,
    this.refreshCallback,
  }) : super(key: key);
  _TopicItemState createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> {
  // 跳转到详情页
  void showCommentPage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CommentList(
            topicModel: widget.topicModel,
            type: 'self',
          );
        });
  }

  // 点赞
  Future<void> supportHandler() async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      var result = await support(
        userid: userModel.userid,
        targetId: widget.topicModel.topicid,
        type: 1,
      );
      if (result['noerr'] == 0) {
        widget.refreshCallback();
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  Future<void> deleteTopicCallback() async {
    try {
      var result = await deleteTopic(topicId: widget.topicModel.topicid);
      if (result['noerr'] == 0) {
        await widget.refreshCallback();
        Toast.show(
          '删除成功',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      } else {
        Toast.show(
          '删除失败',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      }
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 40,
                      height: 40,
                      imageUrl: widget.topicModel.userImage,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
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
                          widget.topicModel.userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.topicModel.createTime,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: deleteTopicCallback,
                child: Icon(
                  Icons.clear,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
          Container(
            width: screenWidth,
            margin: EdgeInsets.only(left: 40, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.topicModel.topicContent.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Colors.black,
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
    List<String> images = widget.topicModel.topicContent.images;
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
        return Container(
          margin: EdgeInsets.only(left: 40, top: 10),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            '#' + widget.topicModel.topicType,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              color: Color(0xFF5B86E5),
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
                  widget.topicModel.comment.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
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
                  color: widget.topicModel.support.action
                      ? Color(0xFF5B86E5)
                      : Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  widget.topicModel.support.count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
