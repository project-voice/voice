import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();
// 点赞
Future<dynamic> support({
  int userid,
  int targetId,
  int type,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/support/support',
    queryParameters: {
      'user_id': userid,
      'target_id': targetId,
      'type': type,
    },
  );
  return response.data;
}
