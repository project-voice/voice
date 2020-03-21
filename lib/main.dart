import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/provider/TopicProvider.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/provider/VideoProvider.dart';
import 'package:voice/routes/Application.dart';
import 'package:voice/routes/Routes.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TopicProvider>(create: (_) => TopicProvider()),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ChangeNotifierProvider<VideoProvider>(create: (_) => VideoProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '语声',
      theme: ThemeData(
        primaryColor: Color(0xFF5B86E5),
      ),
      onGenerateRoute: Application.router.generator,
      home: IndexPage(),
    );
  }
}
