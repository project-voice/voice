import 'package:flutter/material.dart';
import 'package:voice/routes/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        routes: routes);
  }
}
