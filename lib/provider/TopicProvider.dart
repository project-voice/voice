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
    topicTitle = json['topic_title'].cast<String>();
    topicContent = json['topic_content']
        .map((topics) {
          return topics
              .map((topic) {
                return TopicModel.fromJson(topic);
              })
              .cast<TopicModel>()
              .toList();
        })
        .cast<List<TopicModel>>()
        .toList();

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

  updateSupport(String type, int topicid, Map<String, dynamic> supportJson) {
    Support support = Support.fromJson(supportJson);
    int idx = topicTitle.indexOf(type);
    topicContent[idx].forEach((topicModel) {
      if (topicModel.topicid == topicid) {
        topicModel.support = support;
      }
    });
    topicContent[0].forEach((topicModel) {
      if (topicModel.topicid == topicid) {
        topicModel.support = support;
      }
    });
    notifyListeners();
  }

  updateComment(String type, int, topicIdx, int comment) {
    num idx = topicTitle.indexOf(type);
    topicContent[idx][topicIdx].comment = comment;
    notifyListeners();
  }
}
