import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/constants/index.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/routes/Application.dart';
import 'package:voice/routes/Routes.dart';
import 'package:voice/routes/bottomBar.dart';

class IndexPage extends StatefulWidget {
  final String title;
  IndexPage({Key key, this.title}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  num _selectedKey = 0;
  void releaseTipicHandler() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> releaseWidgets = releasePages.map((release) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserModel userModel = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).userInfo;
                    if (userModel.userid == 0) {
                      Application.router.navigateTo(
                        context,
                        Routes.loginPage,
                        transition: TransitionType.native,
                      );
                      return;
                    }
                    Navigator.of(context).pop();
                    Application.router.navigateTo(
                      context,
                      release['page'],
                      transition: TransitionType.native,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(color: Colors.grey[400], blurRadius: 4.0)
                        ]),
                    child: ClipOval(
                      child: Image.asset(release['iconUrl'],
                          width: 50, height: 50),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    release['text'],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          }).toList();
          return Container(
              height: 130,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: releaseWidgets));
        });
  }

  @override
  Widget build(BuildContext context) {
    List<IconButton> tabBarList = new List();
    bottomTabBar.forEach((item) {
      num index = bottomTabBar.indexOf(item);
      IconData icon = item['icon'];
      Color color =
          index == this._selectedKey ? Color(0xFF36D1DC) : Colors.white;
      tabBarList.add(
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: () {
            setState(() {
              this._selectedKey = index;
            });
          },
        ),
      );
    });

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF5B86E5),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabBarList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        onPressed: releaseTipicHandler,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: bottomTabBar[_selectedKey]['page'],
    );
  }
}
