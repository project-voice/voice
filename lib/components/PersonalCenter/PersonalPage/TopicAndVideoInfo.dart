import 'package:flutter/material.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/VideoModel.dart';

class TopicAndVideoInfo extends StatelessWidget {
  final List<TopicModel> topicList;
  final List<VideoModel> videoList;
  TopicAndVideoInfo({Key key, this.topicList, this.videoList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
