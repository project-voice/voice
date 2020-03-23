import 'package:flutter/material.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/Info/VideoItem.dart';
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.only(bottom: 20),
        child: Wrap(
          spacing: 4,
          children: videoList
              .map((video) {
                return VideoItem(
                  videoModel: video,
                  refreshCallback: refreshCallback,
                );
              })
              .cast<Widget>()
              .toList(),
        ),
      ),
    );
  }
}
