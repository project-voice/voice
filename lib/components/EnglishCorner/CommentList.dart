import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Comment.dart';
import 'package:voice/components/common/CommentItem.dart';
import 'package:voice/model/CommentModel.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/routes/Application.dart';
import 'package:voice/routes/Routes.dart';

class CommentList extends StatefulWidget {
  final TopicModel topicModel;
  final String type;
  CommentList({Key key, this.topicModel, this.type = ''}) : super(key: key);
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<CommentModel> commentList = [];
  TextEditingController _commentController;
  int count = 10;
  int page = 1;
  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    featchRequest(page++, count, 'load');
  }

  // 请求列表数据
  Future<void> featchRequest(int page, int count, String type) async {
    try {
      var result = await getCommentList(
        targetId: widget.topicModel.topicid,
        page: page,
        count: count,
        type: 1,
      );
      if (result['noerr'] == 0) {
        List<CommentModel> tempList = result['data']
            .map((comment) {
              return CommentModel.fromJson(comment);
            })
            .cast<CommentModel>()
            .toList();
        setState(() {
          if (type == 'load') {
            commentList.addAll(tempList);
          } else {
            commentList = tempList;
          }
        });
      }
    } catch (err) {
      print(err);
    }
  }

  // 评论
  Future<void> commentHandler() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      TopicProvider topicProvider = Provider.of<TopicProvider>(
        context,
        listen: false,
      );
      if (userModel.userid == 0) {
        // 跳转到登录
        Application.router.navigateTo(
          context,
          Routes.loginPage,
          transition: TransitionType.native,
        );
        return;
      }
      String commentContent = _commentController.text;
      var result = await comment(
        targetId: widget.topicModel.topicid,
        userid: userModel.userid,
        commentContent: commentContent,
        type: 1,
      );
      if (result['noerr'] == 0) {
        page = 1;
        // 重新获取评论列表
        featchRequest(page++, count, 'refresh');
        // 更新videoProvider中的数据
        if (widget.type.isEmpty) {
          topicProvider.updateComment(
            widget.topicModel.topicType,
            widget.topicModel.topicid,
            widget.topicModel.comment + 1,
          );
        }
      }
      _commentController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (err) {
      print(err);
    }
  }

  Future<void> onLoadHandler() async {
    await featchRequest(page++, count, 'load');
  }

  Future<void> onRefreshHandler() async {
    page = 1;
    await featchRequest(page++, count, 'refresh');
  }

  @override
  void dispose() {
    super.dispose();
    _commentController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 500,
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Center(
                child: Text(
                  '评论列表',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: commentList.isEmpty
                  ? Container(
                      // height: 376,
                      child: Center(
                        child: Text(
                          '这个视频还没有评论，快来评论呀！',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                  : Container(
                      height: 200,
                      child: EasyRefresh(
                        onLoad: onLoadHandler,
                        onRefresh: onRefreshHandler,
                        footer: MaterialFooter(),
                        header: MaterialHeader(),
                        child: ListView.builder(
                          itemCount: commentList.length,
                          itemBuilder: (context, index) {
                            return CommentItem(
                              commentData: commentList[index],
                            );
                          },
                        ),
                      ),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: '写下你的评论',
                  hintStyle: TextStyle(
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  suffix: GestureDetector(
                    onTap: commentHandler,
                    child: Text(
                      '评论',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
