import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:voice/store/action/action.dart';

import 'package:voice/api/User.dart';
import 'package:toast/toast.dart';

class FluentSpeak extends StatefulWidget {
  _FluentSpeakState createState() => _FluentSpeakState();
}

class _FluentSpeakState extends State<FluentSpeak> {
  List<Widget> list = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
