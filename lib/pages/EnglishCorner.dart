import 'package:flutter/material.dart';
import 'package:voice/components/EnglishCorner/EnglishCornerContent.dart';

class EnglishCorner extends StatefulWidget {
  _EnglishCornerState createState() => _EnglishCornerState();
}

class _EnglishCornerState extends State<EnglishCorner>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ['全部', '每日一语', '上班摸鱼', '开心一下', '一图胜千言', '今天学到了', '画个知识点'];
  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    // TODO:请求数据
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
    return TabBarView(
      controller: _tabController,
      children: tabs.map((tab) {
        return EnglishCornerContent();
      }).toList(),
    );
  }
}
