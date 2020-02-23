import 'dart:io';
import 'package:dio/dio.dart';
import './config.dart';

Dio _dio = new Dio();

Future<dynamic> releaseFeedback({
  int userid,
  String feedbackContent,
}) async {
  FormData formData = FormData.fromMap({
    'user_id': userid,
    'feedback_content': feedbackContent,
  });
  Response response = await _dio.post(
    '$BASE_URL/feedback/release-feedback',
    data: formData,
  );
  return response.data;
}
