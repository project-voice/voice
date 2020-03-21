import 'dart:io';

import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

// 获取第一页的接口
Future<dynamic> getVideoListAll({
  int userid,
}) async {
  try {
    Response respose =
        await _dio.get('$BASE_URL/video/get-video-all', queryParameters: {
      'user_id': userid,
    });

    return respose.data;
  } catch (err) {
    print('hahah' + err.toString());
  }
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

// 发布短视频
Future<dynamic> releaseVideo({
  int userid,
  String videoDescription,
  File video,
  File image,
}) async {
  FormData formData = FormData.fromMap({
    'user_id': userid,
    'video_description': videoDescription,
    'video': await MultipartFile.fromFile(video.path),
    'image': await MultipartFile.fromFile(image.path),
  });
  Response response = await _dio.post('$BASE_URL/video/release-video',
      data: formData, onSendProgress: (int send, int total) {
    print(send);
    print(total);
  });
  return response.data;
}
