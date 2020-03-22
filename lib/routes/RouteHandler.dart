// 主页
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:voice/pages/EnglishCorner/ReleaseTopic.dart';
import 'package:voice/pages/FluentSpeak/QuestionDetails.dart';
import 'package:voice/pages/FluentSpeak/RankList.dart';
import 'package:voice/pages/Home/ReleaseVideo.dart';
import 'package:voice/pages/Login/EmailCheck.dart';
import 'package:voice/pages/Login/Login.dart';
import 'package:voice/pages/Login/NewPassword.dart';
import 'package:voice/pages/Login/Register.dart';
import 'package:voice/pages/PersonalCenter/FollowList.dart';
import 'package:voice/pages/PersonalCenter/OpinionFeedback.dart';
import 'package:voice/pages/PersonalCenter/PersonalPage.dart';
import 'package:voice/pages/PersonalCenter/Setup.dart';
import 'package:voice/pages/PersonalCenter/SystemMessage.dart';
import 'package:voice/pages/index.dart';

// 首页
Handler rootHandler = Handler(
  handlerFunc: (BuildContext context, Map params) {
    return IndexPage();
  },
);
// 登录
Handler loginHander = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return Login();
  },
);
// 邮箱验证
Handler emailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    String type = params['type'][0];
    return EmailCheck(type: type);
  },
);
// 注册
Handler registerHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    String email = params['email'][0];
    return Register(email: email);
  },
);
// 找回密码
Handler newpasswordHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    int userId = int.parse(params['userId'][0]);
    return NewPassword(userId: userId);
  },
);

// 发布视频
Handler releaseVideoHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return ReleaseVideo();
  },
);

// 发布话题
Handler releaseTopicHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return ReleaseTopic();
  },
);
// 个人中心相关
// 我关注的
Handler followHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return FollowList();
  },
);
// 意见反馈
Handler feedbackHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return OpinionFeedback();
  },
);
// 个人主页
Handler personalPageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return PersonalPage();
  },
);
// 设置
Handler setupHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return Setup();
  },
);
// 系统消息
Handler messageHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return SystemMessage();
  },
);
// 流利说答题
Handler questionDetailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    int stageNum = int.parse(params['stageNum'][0]);
    return QuestionDetails(stageNum: stageNum);
  },
);
// 积分榜单
Handler rankHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List> params) {
    return RankList();
  },
);
