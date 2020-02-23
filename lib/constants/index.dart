import 'package:flutter/material.dart';

List personalCenterPagesRoute = [
  {
    'icon': Icons.lightbulb_outline,
    'iconColor': Colors.blue,
    'title': '系统消息',
    'page': 'systemMessage',
  },
  {
    'icon': Icons.home,
    'iconColor': Colors.orange,
    'title': '个人主页',
    'page': 'releaseList'
  },
  {
    'icon': Icons.thumb_up,
    'iconColor': Colors.green,
    'title': '我关注的',
    'page': 'followList',
  },
  {
    'icon': Icons.question_answer,
    'iconColor': Colors.grey,
    'title': '意见反馈',
    'page': 'opinionFeedback',
  },
  {
    'icon': Icons.settings,
    'iconColor': Colors.grey,
    'title': '设置',
    'page': 'setup',
  }
];
