import 'package:flutter/material.dart';
import 'package:voice/routes/Routes.dart';

List personalCenterPagesRoute = [
  {
    'icon': Icons.lightbulb_outline,
    'iconColor': Colors.blue,
    'title': '系统消息',
    'page': Routes.messagePage,
  },
  {
    'icon': Icons.home,
    'iconColor': Colors.orange,
    'title': '个人主页',
    'page': Routes.personalPage,
  },
  {
    'icon': Icons.thumb_up,
    'iconColor': Colors.green,
    'title': '我关注的',
    'page': Routes.followPage,
  },
  {
    'icon': Icons.question_answer,
    'iconColor': Colors.grey,
    'title': '意见反馈',
    'page': Routes.feedbackPage,
  },
  {
    'icon': Icons.settings,
    'iconColor': Colors.grey,
    'title': '设置',
    'page': Routes.setupPage,
  }
];

List releasePages = [
  {
    'text': '发布视频',
    'iconUrl': 'assets/images/release-video.jpg',
    'page': Routes.releaseVideoPage,
  },
  {
    'text': '发布主题',
    'iconUrl': 'assets/images/release-topic.png',
    'page': Routes.releaseTopicPage,
  },
];
