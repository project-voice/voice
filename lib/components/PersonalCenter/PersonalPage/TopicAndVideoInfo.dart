import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/Info/TopicInfo.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/Info/VideoInfo.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/VideoModel.dart';

class TopicAndVideoInfo extends StatefulWidget {
  final List<TopicModel> topicList;
  final List<VideoModel> videoList;
  final Function topicRefresh;
  final Function videoRefresh;

  TopicAndVideoInfo({
    Key key,
    this.topicList,
    this.videoList,
    this.topicRefresh,
    this.videoRefresh,
  }) : super(key: key);
  _TopicAndVideoInfoState createState() => _TopicAndVideoInfoState();
}

class _TopicAndVideoInfoState extends State<TopicAndVideoInfo> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    num screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '我发布的',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: Colors.grey[200],
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      '话题',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            _index == 1 ? FontWeight.normal : FontWeight.bold,
                        color: _index == 1 ? Colors.grey : Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '短视频',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            _index == 0 ? FontWeight.normal : FontWeight.bold,
                        color: _index == 0 ? Colors.grey : Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            padding: EdgeInsets.only(bottom: 120),
            child: Swiper(
              itemCount: 2,
              onIndexChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              itemBuilder: (context, index) {
                return index == 0
                    ? TopicInfo(
                        topicList: widget.topicList,
                        refreshCallback: widget.topicRefresh,
                      )
                    : VideoInfo(
                        videoList: widget.videoList,
                        refreshCallback: widget.videoRefresh,
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
