import 'package:flutter/material.dart';

class ReleaseVideo extends StatefulWidget {
  _ReleaseVideoState createState() => _ReleaseVideoState();
}

class _ReleaseVideoState extends State<ReleaseVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布视频'),
        centerTitle: true,
      ),
      body: Container(child: Text('发布视频')),
    );
  }
}
