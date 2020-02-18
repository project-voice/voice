import 'package:flutter/material.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/pages/Login/Login.dart';
import 'package:voice/pages/Login/EmailCheck.dart';
import 'package:voice/pages/Login/Register.dart';
import 'package:voice/pages/Login/NewPassword.dart';
import 'package:voice/components/Release/ReleaseTopic.dart';
import 'package:voice/components/Release/ReleaseVideo.dart';

Map routes = <String, WidgetBuilder>{
  // 首页
  '/': (context) => IndexPage(title: 'Flutter Demo'),
  // 登录、注册、密码找回
  'login': (context) => Login(),
  'emailCheck': (context) => EmailCheck(),
  'register': (context) => Register(),
  'newPassword': (context) => NewPassword(),
  // 发布主题、视频
  'releaseTopic': (context) => ReleaseTopic(),
  'releaseVideo': (context) => ReleaseVideo(),
};
