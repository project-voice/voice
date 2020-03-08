import 'package:flutter/material.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/provider/VideoProvider.dart';
import 'package:voice/routes/index.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TopicProvider>(create: (_) => TopicProvider()),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ChangeNotifierProvider<VideoProvider>(create: (_) => VideoProvider())
    ],
    child: MyApp(title: '语声'),
  ));
}

class MyApp extends StatelessWidget {
  final String title;
  MyApp({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Color(0xFF5B86E5),
      ),
      initialRoute: '/', //名字为/的路由作为应用的home(首页)
      onGenerateRoute: (RouteSettings settings) {
        // 路由生成钩子
        return MaterialPageRoute(builder: (context) {
          String routeName = settings.name;
          print(routeName);
          return;
        });
      },
      routes: routes,
    );
  }
}
