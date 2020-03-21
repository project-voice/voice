import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/components/EnglishCorner/MessageItem.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';

class EnglishCornerContent extends StatefulWidget {
  final List<TopicModel> topicContent;
  final int index;
  final TabController controller;
  final Function refreshCallback;
  EnglishCornerContent({
    Key key,
    this.topicContent,
    this.index,
    this.controller,
    this.refreshCallback,
  }) : super(key: key);

  _EnglishCornerContentState createState() => _EnglishCornerContentState();
}

class _EnglishCornerContentState extends State<EnglishCornerContent> {
  EasyRefreshController _easyRefreshController;
  int page = 2;
  int count = 10;
  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    super.dispose();
    _easyRefreshController?.dispose();
  }

  Future<void> fetchRequestNext(int page, int count) async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      TopicProvider topicProvider = Provider.of<TopicProvider>(
        context,
        listen: false,
      );

      List<String> tabs = topicProvider.topicTitle;
      String tab = tabs[widget.index];
      var result = await getNextTopicList(
        userid: userModel.userid,
        page: page,
        count: count,
        topicType: tab,
      );
      if (result['noerr'] == 0) {
        topicProvider.addTopicList(tab, result['data']);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> onLoadHandler() async {
    await fetchRequestNext(page++, count);
  }

  Future<void> onRefreshHandler() async {
    page = 2;
    widget.refreshCallback(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: EasyRefresh(
        onLoad: onLoadHandler,
        onRefresh: onRefreshHandler,
        controller: _easyRefreshController,
        footer: MaterialFooter(),
        header: MaterialHeader(),
        child: ListView.separated(
          itemCount: widget.topicContent.length,
          itemBuilder: (BuildContext context, int index) {
            TopicModel content = widget.topicContent[index];
            return MessageItem(
              content: content,
              controller: widget.controller,
              index: widget.index,
            );
          },
          separatorBuilder: (context, index) => Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Divider(height: .0),
          ),
        ),
      ),
    );
  }
}
