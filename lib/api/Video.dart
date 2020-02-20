import 'dart:io';

import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

// 获取第一页的接口
Future<dynamic> getVideoListAll({
  int userid,
  int count,
}) async {
  try {
    Response respose =
        await _dio.get('$BASE_URL/video/get-video-all', queryParameters: {
      'user_id': userid,
      'count': count,
    });

    return respose.data;
  } catch (err) {
    print('hahah' + err.toString());
  }
}

// 获取下一页的数据
Future<dynamic> getNextVideoList({
  int userid,
  int count,
  int page,
  String type,
}) async {
  Response response = await _dio.get('$BASE_URL/video/get-video',
      queryParameters: {
        'user_id': userid,
        'count': count,
        'page': page,
        'type': type
      });
  return response.data;
}

// 分享
Future<dynamic> actionShare({
  int videoid,
}) async {
  Response response = await _dio.get('$BASE_URL/video/share', queryParameters: {
    'video_id': videoid,
  });
  return response.data;
}

// 点赞
Future<dynamic> actionSupport({
  int userid,
  int videoid,
}) async {
  Response response =
      await _dio.get('$BASE_URL/video/support', queryParameters: {
    'user_id': userid,
    'video_id': videoid,
  });
  return response.data;
}

// 评论
Future<dynamic> actionComment({
  int releaseid,
  int userid,
  int videoid,
  String commentContent,
}) async {
  Response response =
      await _dio.get('$BASE_URL/video/comment', queryParameters: {
    'release_id': releaseid,
    'user_id': userid,
    'video_id': videoid,
    'comment_content': commentContent,
  });
  return response.data;
}

// 获取评论列表，分页。
Future<dynamic> getCommentList({
  int videoid,
  int page,
  int count,
}) async {
  Response response =
      await _dio.get('$BASE_URL/video/comment-list', queryParameters: {
    'video_id': videoid,
    'page': page,
    'count': count,
  });
  return response.data;
}

// 发布短视频
Future<dynamic> releaseVideo({
  int userid,
  String userDescription,
  File file,
}) async {
  FormData formData = FormData.fromMap({
    'user_id': userid,
    'user_description': userDescription,
    'video': await MultipartFile.fromFile(file.path),
  });
  Response response =
      await _dio.post('$BASE_URL/video/release-video', data: formData);
  return response.data;
}
