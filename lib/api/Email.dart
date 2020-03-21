import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();
// 发送邮箱邮箱
Future<dynamic> emailIdentity({
  String userEmail,
  String type,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/email/send-email',
    queryParameters: {
      'user_email': userEmail,
      'type': type,
    },
  );
  return response.data;
}

// 验证码验证
Future<dynamic> checkIdentity({
  String userEmail,
  String identity,
}) async {
  Response response = await _dio.get(
    '$BASE_URL/email/check-identity',
    queryParameters: {
      'user_email': userEmail,
      'identity': identity,
    },
  );
  return response.data;
}
