import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:voice/routes/index.dart';
import 'package:voice/store/index.dart';

void main() {
  return runApp(MyApp(title: '语声', store: store));
}

class MyApp extends StatelessWidget {
  final Store<dynamic> store;
  final String title;
  MyApp({Key key, this.store, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
            title: 'Flutter Deom',
            theme: ThemeData(
                // 全局主题
                primarySwatch: Colors.orange),
            initialRoute: '/', //名字为/的路由作为应用的home(首页)
            // 路由生成钩子
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(builder: (context) {
                String routeName = settings.name;
                print(routeName);
                return;
              });
            },
            routes: routes));
  }
}
