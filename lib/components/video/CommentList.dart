import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/components/common/CommentItem.dart';
import 'package:voice/model/CommentModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/model/VideoModel.dart';
import 'package:voice/provider/UserModel.dart';
import 'package:voice/provider/VideoProvider.dart';

class CommentList extends StatefulWidget {
  final VideoModel videoData;
  final String type;
  final int index;
  CommentList({Key key, this.videoData, this.type, this.index})
      : super(key: key);
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
        videoid: widget.videoData.videoid,
        page: page,
        count: count,
      );
      if (result['noerr'] == 0) {
        setState(() {
          if (type == 'load') {
            List<CommentModel> tempList =
                (result['data'] as List).map((comment) {
              return CommentModel.fromJson(comment);
            }).toList();
            commentList.addAll(tempList);
          } else {
            commentList = (result['data'] as List).map((comment) {
              return CommentModel.fromJson(comment);
            }).toList();
          }
        });
      }
      print(result);
    } catch (err) {
      print(err);
    }
  }

  // 评论
  Future<void> commentHandler() async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      VideoProvider videoProvider =
          Provider.of<VideoProvider>(context, listen: false);
      if (userModel.userid == 0) {
        // 跳转到登录
        Navigator.of(context).pushNamed('login');
      }
      String commentContent = _commentController.text;
      var result = await actionComment(
        releaseid: widget.videoData.userid,
        videoid: widget.videoData.videoid,
        userid: userModel.userid,
        commentContent: commentContent,
      );
      if (result['noerr'] == 0) {
        page = 1;
        // 重新获取评论列表
        featchRequest(page++, count, 'load');
        // 更新videoProvider中的数据
        videoProvider.updateComment(
            widget.type, widget.index, widget.videoData.comment + 1);
      }
      _commentController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      print(result);
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
    String titleText =
        commentList.isEmpty ? '暂无评论' : '${commentList.length.toString()}条评论';

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
                titleText,
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
                        child: Text('这个视频还没有评论，快来评论呀！',
                            style: TextStyle(fontSize: 14))),
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
                      top: BorderSide(width: 0.5, color: Colors.grey[300])))),
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
                  child: Text('评论', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
