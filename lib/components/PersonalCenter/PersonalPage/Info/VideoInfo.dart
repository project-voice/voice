import 'package:flutter/material.dart';
import 'package:voice/model/VideoModel.dart';

class VideoInfo extends StatelessWidget {
  final List<VideoModel> videoList;
  final Function refreshCallback;
  VideoInfo({
    Key key,
    this.videoList,
    this.refreshCallback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
