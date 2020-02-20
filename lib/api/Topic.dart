import 'dart:io';
import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

// 发布话题
Future<dynamic> releaseTopic({
  num userId,
  String topicType,
  List<File> files,
  String content,
}) async {
  List images = [];
  for (num i = 0; i < files.length; i++) {
    String path = files[i].path;
    images.add(await MultipartFile.fromFile(path));
  }
  try {
    FormData formData = FormData.fromMap({
      'user_id': userId,
      'topic_type': topicType,
      'images': images,
      'content': content
    });
    Response response =
        await _dio.post('$BASE_URL/topic/release-topic', data: formData);
    return response.data;
  } catch (err) {
    print(err);
  }
}

// 获取话题列表第一页

Future<dynamic> getTopicListAll({
  int userid,
  int count,
}) async {
  Response response =
      await _dio.get('$BASE_URL/topic/get-topic-all', queryParameters: {
    'user_id': userid,
    'count': count,
  });
  return response.data;
}

// 获取话题列表下一页
Future<dynamic> getNextTopicList({
  int userid,
  String topicType,
  int page,
  int count,
}) async {
  Response response =
      await _dio.get('$BASE_URL/topic/get-topic', queryParameters: {
    'user_id': userid,
    'topic_type': topicType,
    'page': page,
    'count': count,
  });
  return response.data;
}

// 点赞
Future<dynamic> support({
  int userid,
  int topicid,
}) async {
  Response response =
      await _dio.get('$BASE_URL/topic/support', queryParameters: {
    'user_id': userid,
    'topic_id': topicid,
  });
  return response.data;
}

// 评论
Future<dynamic> comment({
  int releaseid,
  int userid,
  int topicid,
  String commentContent,
}) async {
  Response response =
      await _dio.get('$BASE_URL/topic/comment', queryParameters: {
    'release_id': releaseid,
    'user_id': userid,
    'topic_id': topicid,
    'comment_content': commentContent,
  });
  return response.data;
}

// 评论列表,分页
Future<dynamic> getCommentList({
  int topicid,
  int count,
  int page,
}) async {
  Response response =
      await _dio.get('$BASE_URL/topic/comment_list', queryParameters: {
    'topic_id': topicid,
    'count': count,
    'page': page,
  });
  return response.data;
}
