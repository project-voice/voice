import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Topic.dart';
import 'package:voice/components/EnglishCorner/EnglishCornerContent.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserModel.dart';

class EnglishCorner extends StatefulWidget {
  _EnglishCornerState createState() => _EnglishCornerState();
}

class _EnglishCornerState extends State<EnglishCorner>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final int count = 10;
  bool isRequest = false;
  List<int> pages = [];
  @override
  void initState() {
    super.initState();
    fetchRequestAll(count);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  Future<void> fetchRequestAll(count) async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      TopicProvider topicProvider =
          Provider.of<TopicProvider>(context, listen: false);
      var result = await getTopicListAll(
        userid: userModel.userid,
        count: count,
      );
      if (result['noerr'] == 0) {
        topicProvider.initTopicList(result['data']);
        pages = result['data']['topic_title']
            .map((item) {
              return 1;
            })
            .cast<int>()
            .toList();
      }
      setState(() {
        isRequest = true;
      });
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  TabController createTabController(num len) {
    if (_tabController == null) {
      _tabController = TabController(initialIndex: 0, length: len, vsync: this);
    }
    return _tabController;
  }

  @override
  Widget build(BuildContext context) {
    return isRequest
        ? Scaffold(
            appBar: AppBar(
              // AppBar只存在tabBar 不存在title的情况
              flexibleSpace: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(child: SizedBox()),
                    getTabBar(),
                  ],
                ),
              ),
            ),
            body: getTabBarPage(),
          )
        : Container(child: Center(child: CircularProgressIndicator()));
  }

  Widget getTabBar() {
    return Consumer<TopicProvider>(
      builder: (context, topicProvider, child) {
        List<String> tabs = topicProvider.topicTitle;
        createTabController(tabs.length);
        return TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs
              .map((tab) => Tab(
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget getTabBarPage() {
    return Consumer<TopicProvider>(
      builder: (context, topicProvider, child) {
        List<String> tabs = topicProvider.topicTitle;
        List<List<TopicModel>> topicContent = topicProvider.topicContent;
        createTabController(tabs.length);
        return TabBarView(
          controller: _tabController,
          children: tabs.map((tab) {
            int index = tabs.indexOf(tab);
            return EnglishCornerContent(
              controller: _tabController,
              index: index,
              topicContent: topicContent[index],
            );
          }).toList(),
        );
      },
    );
  }
}
