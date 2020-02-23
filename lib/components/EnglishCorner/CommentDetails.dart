import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/components/common/CommentItem.dart';
import 'package:voice/model/CommentModel.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';

class CommentDetails extends StatefulWidget {
  _CommentDetailsState createState() => _CommentDetailsState();
}

class _CommentDetailsState extends State<CommentDetails> {
  TopicModel topicModel;
  CommentModel commentModel;
  TextEditingController _textEditingController;
  EasyRefreshController _easyRefreshController;
  int page = 1;
  int count = 10;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _easyRefreshController = EasyRefreshController();
    Future.microtask(() {
      setState(() {
        topicModel = ModalRoute.of(context).settings.arguments;
        fetchRequest('refresh', page++, count);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
    _easyRefreshController?.dispose();
  }

  // 获取评论列表，分页
  Future<void> fetchRequest(String type, int page, int count) async {
    try {
      var result = await getCommentList(
        topicid: topicModel.topicid,
        page: page,
        count: count,
      );
      if (result['noerr'] == 0) {
        print(result['data']);
        CommentModel tempModel = CommentModel.fromJson(result['data']);
        setState(() {
          if (type == 'load') {
            commentModel.commentList.addAll(tempModel.commentList);
          } else {
            commentModel = tempModel;
          }
        });
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  Future<void> onLoadHandler() async {
    await fetchRequest('load', page++, count);
  }

  Future<void> onRefreshHandler() async {
    page = 1;
    await fetchRequest('refresh', page++, count);
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
        topicid: topicModel.topicid,
      );
      if (result['noerr'] == 0) {
        topicProvider.updateSupport(
          topicModel.topicType,
          topicModel.topicid,
          result['data'],
        );
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  // 评论
  Future<void> releaseComment() async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      TopicProvider topicProvider =
          Provider.of<TopicProvider>(context, listen: false);
      if (userModel.userid == 0) {
        Navigator.of(context).pushNamed('login');
        return;
      }
      String commentContent = _textEditingController.text;
      var result = await comment(
        releaseid: topicModel.userid,
        userid: userModel.userid,
        topicid: topicModel.topicid,
        commentContent: commentContent,
      );
      if (result['noerr'] == 0) {
        _textEditingController.clear();
        page = 1;
        fetchRequest('refresh', page++, count);
        // 更新Topic中的数据
        topicProvider.updateComment(
          topicModel.topicType,
          topicModel.topicid,
          topicModel.comment + 1,
        );
        FocusScope.of(context).requestFocus(FocusNode());
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;

    return topicModel == null
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text('话题详情'),
              centerTitle: true,
            ),
            body: Container(
              width: screenWidth,
              color: Colors.grey[200],
              child: EasyRefresh(
                controller: _easyRefreshController,
                onLoad: onLoadHandler,
                onRefresh: onRefreshHandler,
                header: MaterialHeader(),
                footer: MaterialFooter(),
                child: ListView(
                  children: <Widget>[
                    topicDetailsWidet(screenWidth),
                    commentListLayout()
                  ],
                ),
              ),
            ),
          );
  }

  Widget commentListLayout() {
    List<Widget> commentWidgetList;
    if (commentModel != null) {
      commentWidgetList = commentModel.commentList.map((comment) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
            ),
          ),
          child: CommentItem(commentData: comment),
        );
      }).toList();
    }
    return commentModel == null
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(16),
            child: commentWidgetList.isEmpty
                ? Center(
                    child: Text(
                      '暂无评论',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: commentWidgetList,
                  ),
          );
  }

  Widget topicDetailsWidet(num screenWidth) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
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
                  imageUrl: topicModel.userImage,
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
                    Text(topicModel.userName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(topicModel.createTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(topicModel.topicContent.text,
                    style: TextStyle(
                      fontSize: 16,
                    )),
                imageLayout(screenWidth)
              ],
            ),
          ),
          tagLayout(),
          commentAndSupport(),
          commenInput()
        ],
      ),
    );
  }

  /// 图片布局
  Widget imageLayout(double screenWidth) {
    List<String> images = topicModel.topicContent.images;
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
        ),
      );
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
    return Container(
      margin: EdgeInsets.only(left: 40, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        '#' + topicModel.topicType,
        style: TextStyle(fontSize: 12, color: Colors.orange),
      ),
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
              Icon(
                Icons.chat,
                size: 20,
                color: Colors.grey[400],
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  topicModel.comment.toString(),
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
                  color: topicModel.support.action
                      ? Colors.orange[400]
                      : Colors.grey[400],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  topicModel.support.count.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget commenInput() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: '写下你的评论',
          hintStyle: TextStyle(
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey[300],
            ),
          ),
          suffix: GestureDetector(
            onTap: releaseComment,
            child: Text(
              '评论',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
