import 'package:flutter/material.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/pages/Login/Login.dart';
import 'package:voice/pages/Login/ForgetPassword.dart';
import 'package:voice/pages/Login/Register.dart';

Map routes = <String, WidgetBuilder>{
  '/': (context) => IndexPage(title: 'Flutter Demo'),
  // 登录、注册、密码找回
  'login': (context) => Login(),
  'forgetPassword': (context) => ForgetPassword(),
  'register': (context) => Register()
};
