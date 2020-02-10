import 'package:flutter/material.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/pages/Login/Login.dart';
import 'package:voice/pages/Login/EmailCheck.dart';
import 'package:voice/pages/Login/Register.dart';
import 'package:voice/pages/Login/NewPassword.dart';

Map routes = <String, WidgetBuilder>{
  // 首页
  '/': (context) => IndexPage(title: 'Flutter Demo'),
  // 登录、注册、密码找回
  'login': (context) => Login(),
  'emailCheck': (context) => EmailCheck(),
  'register': (context) => Register(),
  'newPassword': (context) => NewPassword(),
};
