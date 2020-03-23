import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Answer.dart';
import 'package:voice/api/Question.dart';
import 'package:voice/model/QuestionModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class QuestionDetails extends StatefulWidget {
  final int stageNum;
  QuestionDetails({Key key, this.stageNum}) : super(key: key);
  _QuestionDetailsStage createState() => _QuestionDetailsStage();
}

class _QuestionDetailsStage extends State<QuestionDetails> {
  List<QuestionModel> questionList;
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
      if (result['noerr'] == 0) {
        List<QuestionModel> tempList = result['data']
            .map((item) {
              return QuestionModel.formJson(item);
            })
            .cast<QuestionModel>()
            .toList();
        setState(() {
          questionList = tempList;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Function answerActionCallback(String answerTxt, int index) {
    return () async {
      try {
        if (answerTxt == questionList[index].questionCorrect) {
          print('回答正确');
          UserModel userModel = Provider.of<UserProvider>(
            context,
            listen: false,
          ).userInfo;
          var result = await answer(
            userId: userModel.userid,
            stageNum: widget.stageNum,
            questionId: questionList[index].questionId,
          );
          if (result['noerr'] == 0) {
            await fetchRequest();
            Toast.show(
              '恭喜你，答对了！',
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER,
            );
          }
        } else {
          Toast.show(
            '很遗憾，回答错误',
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
          );
          setState(() {});
        }
      } catch (err) {
        print(err);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    int index = -1;
    if (questionList != null && questionList.isNotEmpty) {
      index = Random().nextInt(questionList.length);
      print(index);
    }
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('第${widget.stageNum}阶段学习'),
        centerTitle: true,
      ),
      body: questionList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : questionList.isEmpty
              ? Center(
                  child: Text('恭喜你，你已经完成了本阶段所有的题目'),
                )
              : Container(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '题目随机出现,请认真思考答题哦！',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            questionList[index].questionTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        questionList[index].questionImage.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl: questionList[index].questionImage,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          width: screenWidth,
                          margin: EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: questionList[index]
                                .questionOption
                                .keys
                                .map((key) {
                                  return GestureDetector(
                                    onTap: answerActionCallback(
                                      questionList[index].questionOption[key],
                                      index,
                                    ),
                                    child: Container(
                                      width: screenWidth,
                                      margin: EdgeInsets.only(top: 8, left: 50),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Text(
                                                key,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth - 120,
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text(
                                              questionList[index]
                                                  .questionOption[key],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .cast<Widget>()
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
