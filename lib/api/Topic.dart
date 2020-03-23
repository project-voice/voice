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
      await _dio.get('$BASE_URL/topic/get-topic-all-first', queryParameters: {
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

Future<dynamic> getTopicToSelf({
  int userId,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/topic/topic-self-list',
    queryParameters: {
      'user_id': userId,
    },
  );
  return response.data;
}

Future<dynamic> deleteTopic({
  int topicId,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/topic/delete',
    queryParameters: {
      'topic_id': topicId,
    },
  );
  return response.data;
}
