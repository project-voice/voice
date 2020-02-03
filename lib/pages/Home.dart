import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:voice/components/Video/VideoAction.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:voice/store/action/action.dart';

const String RECOMMEND_INDEX = '推荐';
const String FOLLOW_INDEX = '关注';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = RECOMMEND_INDEX;

  /// TODO: 请求数据
  @override
  void initState() {
    super.initState();
  }

  /// 当Swiper元素滚动的时候触发。
  void indexChangeHandler(int index) {}

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
              child: StoreConnector(
                converter: (store) {
                  return store.state['vediosData'];
                },
                builder: (context, vediosData) {
                  num count = vediosData.length;
                  return Container(
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
                                vedioData: vediosData[index],
                              );
                            },
                            itemCount: count,
                            onIndexChanged: indexChangeHandler,
                          ),
                  );
                },
              )),
          Positioned(
              top: 30,
              left: 0,
              child: Container(
                  height: 50,
                  width: screenWidth,
                  child: StoreConnector(converter: (store) {
                    return store;
                  }, builder: (context, store) {
                    String selectedTab = store.state['homeSelectedTab'];
                    Function updateTabSelectedDispatch = store.dispatch;
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  updateTabSelectedDispatch(createActionHandler(
                                      ActionTypes.UpdateHomeSelectedTab,
                                      RECOMMEND_INDEX));
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
                                    updateTabSelectedDispatch(
                                        createActionHandler(
                                            ActionTypes.UpdateHomeSelectedTab,
                                            FOLLOW_INDEX));
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
                        ]);
                  })))
        ]));
  }
}
