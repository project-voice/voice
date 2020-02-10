import 'package:dio/dio.dart';

Dio _dio = new Dio();

Future<dynamic> getUser({Map params}) async {
  if (params == null) {
    params = {};
  }
  Response respose =
      await _dio.get('http://jsonplaceholder.typicode.com/posts');
  return respose.data;
}
