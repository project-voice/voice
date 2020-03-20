import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

// 关注
Future<dynamic> actionFollow({
  int userid,
  int followid,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/follow/follow',
    queryParameters: {
      'user_id': userid,
      'follow_id': followid,
    },
  );
  return response.data;
}

// 获取关注人员列表
Future<dynamic> getFollowList({
  int userid,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/follow/follow-list',
    queryParameters: {
      'user_id': userid,
    },
  );
  return response.data;
}

// 取消关注
Future<dynamic> cancelFollow({
  int userid,
  int followid,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/follow/cancel-follow',
    queryParameters: {
      'user_id': userid,
      'follow_id': followid,
    },
  );
  return response.data;
}
