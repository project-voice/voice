import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:voice/routes/RouteHandler.dart';

class Routes {
  // 首页
  static String root = '/';
  // 登录
  static String loginPage = '/loginPage';
  // 邮箱验证
  static String emailPage = '/emailPage';
  // 注册
  static String registerPage = '/registerPage';
  // 找回密码
  static String newpasswordPage = '/newpasswordPage';
  // 发布视频
  static String releaseVideoPage = '/releaseVideoPage';
  // 发布话题
  static String releaseTopicPage = '/releaseTopicPage';
  // 个人中心相关
  // 我关注的
  static String followPage = '/followPage';
  // 意见反馈
  static String feedbackPage = '/feedbackPage';
  // 个人主页
  static String personalPage = '/personalPage';
  // 设置
  static String setupPage = '/setupPage';
  // 系统消息
  static String messagePage = '/messagePage';
  // 流利说相关
  // 答题
  static String questionDetalsPage = '/questionDetalsPage';
  // 积分榜单
  static String rankPage = '/rankPage';
  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        return Container(
          child: Center(
            child: Text('ROUTE WAS NOT FOUND !!!'),
          ),
        );
      },
    );
    // 首页
    router.define(root, handler: rootHandler);
    // 登录
    router.define(loginPage, handler: loginHander);
    // 邮箱验证
    router.define(emailPage, handler: emailHandler);
    // 注册
    router.define(registerPage, handler: registerHandler);
    // 找回密码
    router.define(newpasswordPage, handler: newpasswordHandler);
    // 发布视频
    router.define(releaseVideoPage, handler: releaseVideoHandler);
    // 发布话题
    router.define(releaseTopicPage, handler: releaseTopicHandler);
    // 个人中心相关
    // 我关注的
    router.define(followPage, handler: followHandler);
    // 意见反馈
    router.define(feedbackPage, handler: feedbackHandler);
    // 个人主页
    router.define(personalPage, handler: personalPageHandler);
    // 设置
    router.define(setupPage, handler: setupHandler);
    // 系统消息
    router.define(messagePage, handler: messageHandler);
    // 流利说相关
    // 答题
    router.define(questionDetalsPage, handler: questionDetailsHandler);
    // 积分榜单
    router.define(rankPage, handler: rankHandler);
  }
}
