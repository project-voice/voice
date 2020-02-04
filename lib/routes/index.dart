import 'package:flutter/material.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/pages/Login.dart';

Map routes = <String, WidgetBuilder>{
  '/': (context) => IndexPage(title: 'Flutter Demo'),
  'login': (context) => Login(),
};
