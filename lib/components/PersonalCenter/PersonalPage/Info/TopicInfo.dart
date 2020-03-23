import 'package:flutter/material.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/Info/TopicItem.dart';
import 'package:voice/model/TopicModel.dart';

class TopicInfo extends StatelessWidget {
  final List<TopicModel> topicList;
  final Function refreshCallback;
  TopicInfo({
    Key key,
    this.topicList,
    this.refreshCallback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: topicList.length,
        itemBuilder: (context, index) {
          return TopicItem(
            topicModel: topicList[index],
            refreshCallback: refreshCallback,
          );
        });
  }
}
