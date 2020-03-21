import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();
// 评论
Future<dynamic> comment({
  int userid,
  int targetId,
  String commentContent,
  int type,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/comment/comment',
    queryParameters: {
      'user_id': userid,
      'target_id': targetId,
      'comment_content': commentContent,
      'type': type
    },
  );
  return response.data;
}

// 获取评论列表，分页。
Future<dynamic> getCommentList({
  int targetId,
  int page,
  int count,
  int type,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/comment/comment-list',
    queryParameters: {
      'target_id': targetId,
      'page': page,
      'count': count,
      'type': type
    },
  );
  return response.data;
}
