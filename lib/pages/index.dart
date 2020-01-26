import 'package:flutter/material.dart';
import 'package:voice/routes/bottomBar.dart';
import 'dart:math' as math;

class IndexPage extends StatefulWidget {
  final String title;
  IndexPage({Key key, this.title}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  num _selectedKey = 0;
  num _rotate = 0.0;
  void releaseTipicHandler() {
    print('发布视频或图片');
    // 动画
    setState(() {
      if (this._rotate == 0.0) {
        this._rotate = math.pi / 4;
      } else {
        this._rotate = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IconButton> tabBarList = new List();
    bottomTabBar.forEach((item) {
      num index = bottomTabBar.indexOf(item);
      IconData icon = item['icon'];
      Color color =
          index == this._selectedKey ? Colors.deepOrangeAccent : Colors.white;
      tabBarList.add(IconButton(
        icon: Icon(icon),
        color: color,
        onPressed: () {
          setState(() {
            this._selectedKey = index;
          });
        },
      ));
    });

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Colors.orange[200],
            shape: CircularNotchedRectangle(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tabBarList)),
        floatingActionButton: FloatingActionButton(
          child: Transform.rotate(
            angle: this._rotate,
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
          onPressed: releaseTipicHandler,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: bottomTabBar[_selectedKey]['page']);
  }
}
