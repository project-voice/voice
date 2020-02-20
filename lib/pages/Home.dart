import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Video.dart';
import 'package:voice/components/Video/VideoAction.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/model/VideoModel.dart';
import 'package:voice/provider/UserModel.dart';
import 'package:voice/provider/VideoProvider.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final tabList = ['推荐', '关注'];
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserModel userModel =
          Provider.of<UserProvider>(context, listen: false).userInfo;
      VideoProvider videoProvider =
          Provider.of<VideoProvider>(context, listen: false);
      var result = await getVideoListAll(
        userid: userModel.userid,
        // userid: 6,
        count: 10,
      );
      videoProvider.initVideoList(result['data']);
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                width: 20,
              )),
              Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TabBar(
                    controller: _tabController,
                    tabs: tabList
                        .map((tab) => Text(tab,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )))
                        .toList(),
                  ))
            ],
          ),
        ),
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoData, child) {
          List<VideoModel> followList = videoData.followList;
          List<VideoModel> recommendList = videoData.recommendList;
          bool isRequest = false;
          if (followList.length != 0 || recommendList.length != 0) {
            isRequest = true;
          }
          return isRequest
              ? tabBarViewWidget([recommendList, followList])
              : Container(
                  color: Colors.black,
                  child: Center(child: Text('正在加载')),
                );
        },
      ),
    );
  }

  Widget tabBarViewWidget(List<List<VideoModel>> videoModelList) {
    List<Widget> swiperWidgets = videoModelList.map((videoModels) {
      num count = videoModels.length;
      int idx = videoModelList.indexOf(videoModels);
      String type = idx == 0 ? 'recommend' : 'follow';
      return count == 0
          ? Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  '您还未关注任何人',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ))
          : Swiper(
              loop: false,
              outer: false,
              itemCount: count,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: Container(
                      color: Colors.black,
                      child: VideoAction(
                          vedioData: videoModels[index],
                          type: type,
                          index: index)),
                );
              },
            );
    }).toList();
    return TabBarView(
      controller: _tabController,
      children: swiperWidgets,
    );
  }
}
