import 'package:flutter/material.dart';
import 'package:voice/model/TopicModel.dart';
import 'package:voice/model/VideoModel.dart';

class TopicProvider extends ChangeNotifier {
  List<String> topicTitle;
  List<List<TopicModel>> topicContent;
  TopicProvider() {
    topicTitle = [];
    topicContent = [];
  }
  initTopicList(Map<String, dynamic> json) {
    topicTitle = json['topic_title'];
    topicContent = (json['topic_content'] as List).map((topics) {
      return (topics as List).map((topic) {
        return TopicModel.fromJson(topic);
      }).toList();
    }).toList();
    notifyListeners();
  }

  addTopicList(String type, List json) {
    int idx = topicTitle.indexOf(type);
    List<TopicModel> nextList = json.map((topic) {
      return TopicModel.fromJson(topic);
    }).toList();
    topicContent[idx].addAll(nextList);
    notifyListeners();
  }

  updateSupport(String type, int topicIdx, Map<String, dynamic> supportJson) {
    Support support = Support.fromJson(supportJson);
    int idx = topicTitle.indexOf(type);
    topicContent[idx][topicIdx].support = support;
    notifyListeners();
  }

  updateComment(String type, int, topicIdx, int comment) {
    num idx = topicTitle.indexOf(type);
    topicContent[idx][topicIdx].comment = comment;
    notifyListeners();
  }
}
