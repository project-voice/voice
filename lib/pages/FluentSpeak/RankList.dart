import 'package:flutter/material.dart';

class RankList extends StatefulWidget {
  _RankListState createState() => _RankListState();
}

class _RankListState extends State<RankList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('榜单')), body: Container(child: Text('榜单')));
  }
}
