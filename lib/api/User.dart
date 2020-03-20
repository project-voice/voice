import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();
// 注册
Future<dynamic> register({
  String userName,
  String userPassword,
  String userEmail,
}) async {
  FormData formData = FormData.fromMap({
    'user_name': userName,
    'user_password': userPassword,
    'user_email': userEmail,
  });
  Response response =
      await _dio.post('$BASE_URL/user/register', data: formData);
  return response.data;
}

// 登录
Future<dynamic> login({
  String userPassword,
  String userEmail,
}) async {
  FormData formData = FormData.fromMap({
    'user_password': userPassword,
    'user_email': userEmail,
    'platform': 'mobile'
  });
  Response response = await _dio.post('$BASE_URL/user/login', data: formData);
  return response.data;
}

// 用户信息更新
Future<dynamic> updateUserInfo({
  int userid,
  String key,
  dynamic value,
}) async {
  if (key == 'user_image') {
    value = await MultipartFile.fromFile(value.path);
  }
  FormData formData = FormData.fromMap({
    'user_id': userid,
    'key': key,
    'value': value,
  });
  Response response = await _dio.post('$BASE_URL/user/update', data: formData);
  return response.data;
}
