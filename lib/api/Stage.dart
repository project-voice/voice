import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

Future<dynamic> getStageList({
  int userId,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/stage/stage-list',
    queryParameters: {
      'user_id': userId,
    },
  );
  return response.data;
}
