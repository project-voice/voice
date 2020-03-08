import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

Future<dynamic> getMessageList({int userid}) async {
  Response response =
      await _dio.get('$BASE_URL/message/message-list', queryParameters: {
    'user_id': userid,
  });
  return response.data;
}

Future<dynamic> getTips({int userid}) async {
  Response response =
      await _dio.get('$BASE_URL/message/get-tips', queryParameters: {
    'user_id': userid,
  });
  return response.data;
}
