import 'package:flutter/material.dart';
import 'package:voice/pages/FluentSpeak/QuestionDetails.dart';
import 'package:voice/pages/PersonalCenter/FollowList.dart';
import 'package:voice/pages/PersonalCenter/OpinionFeedback.dart';
import 'package:voice/pages/PersonalCenter/PersonalPage.dart';
import 'package:voice/pages/PersonalCenter/Setup.dart';
import 'package:voice/pages/PersonalCenter/SystemMessage.dart';
import 'package:voice/pages/index.dart';
import 'package:voice/pages/Login/Login.dart';
import 'package:voice/pages/Login/EmailCheck.dart';
import 'package:voice/pages/Login/Register.dart';
import 'package:voice/pages/Login/NewPassword.dart';
import 'package:voice/pages/EnglishCorner/ReleaseTopic.dart';
import 'package:voice/pages/Home/ReleaseVideo.dart';

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
  //话题详情
  // 'commentDetails': (context) => CommentDetails(),
  // 个人中心
  'followList': (context) => FollowList(),
  'opinionFeedback': (context) => OpinionFeedback(),
  'releaseList': (context) => PersonalPage(),
  'setup': (context) => Setup(),
  'systemMessage': (context) => SystemMessage(),
  // 流利说
  'questionDetails': (context) => QuestionDetails()
};
