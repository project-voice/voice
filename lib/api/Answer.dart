import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

Future<dynamic> answer({int userId, int questionId, int stageNum}) async {
  FormData formData = FormData.fromMap({
    'user_id': userId,
    'question_id': questionId,
    'stage_num': stageNum,
  });
  Response response = await _dio.post(
    '$BASE_URL/answer/answer',
    data: formData,
  );
  return response.data;
}

Future<dynamic> getIndexRankAll() async {
  Response response = await _dio.get('$BASE_URL/answer/index-rank-all');
  return response.data;
}

Future<dynamic> getIndexRankToSelf({
  int userId,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/answer/rank-index-self',
    queryParameters: {
      'user_id': userId,
    },
  );
  return response.data;
}
