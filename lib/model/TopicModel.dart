import 'dart:convert';
import './VideoModel.dart';

class TopicModel extends Object {
  int topicid;
  int userid;
  TopicContent topicContent;
  String createTime;
  String topicType;
  String userName;
  String userImage;
  int comment;
  Support support;
  TopicModel({
    this.topicid,
    this.userid,
    this.topicContent,
    this.createTime,
    this.topicType,
    this.userName,
    this.userImage,
    this.comment,
    this.support,
  });
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      topicid: json['topic_id'] as int,
      userid: json['user_id'] as int,
      topicContent: TopicContent.fromJson(json['topic_content']),
      createTime: json['create_time'] as String,
      topicType: json['topic_type'] as String,
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String,
      comment: json['comment'] as int,
      support: Support.fromJson(json['support']),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'topic_id': topicid,
      'user_id': userid,
      'topic_content': topicContent.toJson(),
      'create_time': createTime,
      'topic_type': topicType,
      'user_name': userName,
      'user_image': userImage,
      'comment': comment,
      'support': support.toJson(),
    };
  }
}

class TopicContent {
  String text;
  List<String> images;
  TopicContent({
    this.text,
    this.images,
  });
  factory TopicContent.fromJson(String json) {
    Map jsonMap = jsonDecode(json);
    return TopicContent(
      text: jsonMap['text'] as String,
      images: jsonMap['images'] as List<String>,
    );
  }
  String toJson() {
    return jsonEncode({
      text: text,
      images: images,
    });
  }
}
