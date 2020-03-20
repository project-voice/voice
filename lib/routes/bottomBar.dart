import 'package:flutter/material.dart';
import 'package:voice/pages/Home/Home.dart';
import 'package:voice/pages/EnglishCorner/EnglishCorner.dart';
import 'package:voice/pages/FluentSpeak/FluentSpeak.dart';
import 'package:voice/pages/PersonalCenter/PersonalCenter.dart';

List bottomTabBar = [
  {'icon': Icons.home, 'selected': true, 'page': HomePage()},
  {'icon': Icons.camera, 'selected': false, 'page': EnglishCorner()},
  {'icon': Icons.stars, 'selected': false, 'page': FluentSpeak()},
  {'icon': Icons.person, 'selected': false, 'page': PersonalCenter()}
];
