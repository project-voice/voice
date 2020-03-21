import 'dart:convert';

class QuestionModel extends Object {
  int questionId;
  int stageNum;
  String questionTitle;
  String questionImage;
  Map questionOption;
  String questionCorrect;
  QuestionModel({
    this.stageNum,
    this.questionCorrect,
    this.questionId,
    this.questionImage,
    this.questionOption,
    this.questionTitle,
  });
  factory QuestionModel.formJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionId: json['question_id'] as int,
      stageNum: json['stage_num'] as int,
      questionTitle: json['question_title'] as String,
      questionImage: json['question_image'] as String,
      questionCorrect: json['question_correct'] as String,
      questionOption: jsonDecode(json['question_option']) as Map,
    );
  }
}
