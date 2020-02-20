import 'package:flutter/material.dart';
import 'package:voice/provider/CommentProvider.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserModel.dart';
import 'package:voice/provider/VideoProvider.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
import 'package:voice/routes/index.dart';
// import 'package:voice/store/index.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CommentProvider>(create: (_) => CommentProvider()),
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
      theme: ThemeData(primarySwatch: Colors.orange),
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
