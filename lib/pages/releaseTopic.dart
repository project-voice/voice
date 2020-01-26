import 'package:flutter/material.dart';

class ReleaseTopic extends StatefulWidget {
  final title;
  ReleaseTopic({Key key, this.title}) : super(key: key);

  _ReleaseTopicState createState() => _ReleaseTopicState(title: this.title);
}

class _ReleaseTopicState extends State<ReleaseTopic> {
  final title;
  _ReleaseTopicState({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Container());
  }
}
