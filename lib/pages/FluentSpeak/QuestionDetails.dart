import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Question.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class QuestionDetails extends StatefulWidget {
  final int stageNum;
  QuestionDetails({Key key, this.stageNum}) : super(key: key);
  _QuestionDetailsStage createState() => _QuestionDetailsStage();
}

class _QuestionDetailsStage extends State<QuestionDetails> {
  @override
  void initState() {
    super.initState();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      var result = await getQuestionList(
        userId: userModel.userid,
        stageNum: widget.stageNum,
      );
      print(result);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('祝您学习愉快'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
