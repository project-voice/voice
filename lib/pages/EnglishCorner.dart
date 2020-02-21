import 'package:flutter/material.dart';
import 'package:voice/components/EnglishCorner/EnglishCornerContent.dart';

class EnglishCorner extends StatefulWidget {
  _EnglishCornerState createState() => _EnglishCornerState();
}

class _EnglishCornerState extends State<EnglishCorner>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    // TODO:请求数据
  }

  TabController createTabController(num len) {
    if (_tabController == null) {
      _tabController = TabController(initialIndex: 0, length: len, vsync: this);
    }
    return _tabController;
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) {
      _tabController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // AppBar只存在tabBar 不存在title的情况
          flexibleSpace: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                getTabBar(),
              ],
            ),
          ),
        ),
        body: getTabBarPage());
  }

  Widget getTabBar() {
    List tabs = [];
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: tabs
          .map((tab) => Tab(
              child: Text(tab,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold))))
          .toList(),
    );
  }

  Widget getTabBarPage() {
    List tabs = [];
    List topicContent = [];
    return TabBarView(
      controller: _tabController,
      children: tabs.map((tab) {
        num index = tabs.indexOf(tab);
        return EnglishCornerContent(
            topicContent: topicContent[index],
            index: index,
            controller: _tabController);
      }).toList(),
    );
  }
}
