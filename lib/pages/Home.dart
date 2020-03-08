import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/components/Video/VideoAction.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/model/VideoModel.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/provider/VideoProvider.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _recommendPageController;
  PageController _followPageController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final tabList = ['推荐', '关注'];
  List<GlobalKey<VideoActionState>> recommendGlobalKeys = [];
  List<GlobalKey<VideoActionState>> followGolbalKeys = [];
  bool _render = true;
  bool _isRequest = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _recommendPageController = PageController();
    _followPageController = PageController();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await _prefs;
      String userInfoJson = prefs.getString('user');
      if (userInfoJson != null) {
        Map userInfo = jsonDecode(userInfoJson);
        await userProvider.updateUserInfo(userInfo);
      }
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      VideoProvider videoProvider =
          Provider.of<VideoProvider>(context, listen: false);
      var result = await getVideoListAll(
        userid: userModel.userid,
        count: 10,
      );
      if (result['noerr'] == 0) {
        videoProvider.initVideoList(result['data']);
        setState(() {
          _isRequest = true;
        });
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      print(err);
    }
  }

  void stop() {
    recommendGlobalKeys.forEach((recommendGlobalKey) {
      VideoActionState recommendState = recommendGlobalKey.currentState;
      if (recommendState != null) {
        recommendState.pause();
      }
    });
    followGolbalKeys.forEach((followGolbalkey) {
      VideoActionState followState = followGolbalkey.currentState;
      if (followState != null) {
        followState.pause();
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    stop();
    _render = !_render;
  }

  @override
  void dispose() {
    super.dispose();
    stop();
    _tabController?.dispose();
    _recommendPageController?.dispose();
    _followPageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_render) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: 20,
                ),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  tabs: tabList
                      .map(
                        (tab) => Text(
                          tab,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoData, child) {
          List<VideoModel> followList = videoData.followList;
          List<VideoModel> recommendList = videoData.recommendList;
          return _isRequest
              ? tabBarViewWidget([recommendList, followList])
              : Container(color: Colors.black);
        },
      ),
    );
  }

  Widget tabBarViewWidget(List<List<VideoModel>> videoModelList) {
    List<Widget> swiperWidgets = videoModelList.map((videoModels) {
      num count = videoModels.length;
      int idx = videoModelList.indexOf(videoModels);
      String type = idx == 0 ? 'recommend' : 'follow';
      PageController _controller;
      List<GlobalKey<VideoActionState>> tempGlobalKeys;
      if (idx == 0) {
        recommendGlobalKeys = videoModels.map((item) {
          return GlobalKey<VideoActionState>();
        }).toList();
        _controller = _recommendPageController;
        tempGlobalKeys = recommendGlobalKeys;
      } else {
        followGolbalKeys = videoModels.map((item) {
          return GlobalKey<VideoActionState>();
        }).toList();
        _controller = _followPageController;
        tempGlobalKeys = followGolbalKeys;
      }
      return count == 0
          ? Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  '您还未关注任何人',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            )
          : NotificationListener(
              onNotification: (ScrollNotification scrollNotification) {
                if (scrollNotification is UserScrollNotification) {
                  if (scrollNotification.direction == ScrollDirection.reverse ||
                      scrollNotification.direction == ScrollDirection.forward) {
                    stop();
                  }
                  if (scrollNotification.direction == ScrollDirection.idle) {
                    VideoActionState videoActionState;

                    if (_tabController.index == 0) {
                      videoActionState = recommendGlobalKeys[
                              _recommendPageController.page.toInt()]
                          .currentState;
                    } else {
                      videoActionState =
                          followGolbalKeys[_followPageController.page.toInt()]
                              .currentState;
                    }
                    videoActionState?.play();
                  }
                }
                return true;
              },
              child: PageView.builder(
                  itemCount: count,
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Container(
                        color: Colors.black,
                        child: VideoAction(
                          key: tempGlobalKeys[index],
                          vedioData: videoModels[index],
                          type: type,
                          index: index,
                        ),
                      ),
                    );
                  }),
            );
    }).toList();
    return TabBarView(
      controller: _tabController,
      children: swiperWidgets,
    );
  }
}
