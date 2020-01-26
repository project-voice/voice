import 'package:flutter/material.dart';
import 'package:voice/components/VedioAction.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:voice/mock/videoData.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num count = 0;
  num current = 0;
  List<Map> vedioDatas;

  // TODO: 请求数据
  @override
  void initState() {
    super.initState();
    this.vedioDatas = vedioDatasMock;
    setState(() {
      count = vedioDatas.length;
    });
  }

  /// 当Swiper元素滚动的时候触发。
  void indexChangeHandler(int index) {
    setState(() {
      current = index;
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
                        itemBuilder: (BuildContext context, int index) {
                          return VedioAction(
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
                        child: Text(
                          '推荐',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Container(
                          child: Text(
                        '关注',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ))
                    ]),
              ))
        ]));
  }
}
