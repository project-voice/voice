import 'package:flutter/material.dart';
import 'package:voice/components/Video/VideoAction.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:voice/mock/videoData.dart';

const String RECOMMEND_INDEX = '推荐';
const String FOLLOW_INDEX = '关注';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num count = vedioDatasMock.length;
  num current = 0;
  List<Map> vedioDatas;
  String selectedTab = RECOMMEND_INDEX;

  /// TODO: 请求数据
  @override
  void initState() {
    print('Home');
    super.initState();
    this.vedioDatas = vedioDatasMock;
  }

  /// 当Swiper元素滚动的时候触发。
  void indexChangeHandler(int index) {
    setState(() {
      current = index;
    });
  }

  void updateTabBarSelected(String indexTab) {
    print(indexTab);
    setState(() {
      selectedTab = indexTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.black,
                child: count == 0
                    ? Container()
                    : Swiper(
                        scrollDirection: Axis.vertical,
                        loop: false,
                        itemBuilder: (BuildContext context, int index) {
                          return VideoAction(
                            vedioData: vedioDatas[current],
                          );
                        },
                        itemCount: count,
                        onIndexChanged: indexChangeHandler,
                      ),
              )),
          Positioned(
              top: 30,
              left: 0,
              child: Container(
                height: 50,
                width: screenWidth,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            onTap: () {
                              updateTabBarSelected(RECOMMEND_INDEX);
                            },
                            child: Text(
                              RECOMMEND_INDEX,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedTab == RECOMMEND_INDEX
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                          )),
                      Container(
                          child: GestureDetector(
                              onTap: () {
                                updateTabBarSelected(FOLLOW_INDEX);
                              },
                              child: Text(
                                FOLLOW_INDEX,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedTab == FOLLOW_INDEX
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              )))
                    ]),
              ))
        ]));
  }
}
