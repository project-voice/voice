import 'dart:io';
import 'package:dio/dio.dart';

const String BASE_URL = 'http://39.105.106.168/voice';

Dio _dio = new Dio();

Future<dynamic> releaseTopic(
    {num userId, String topicType, List<File> files, String content}) async {
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
