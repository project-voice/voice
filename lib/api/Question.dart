import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

Future<dynamic> getQuestionList({
  int userId,
  int stageNum,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/question/question-list',
    queryParameters: {
      'user_id': userId,
      'stage_num': stageNum,
    },
  );
  return response.data;
}
