import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Feedback.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class OpinionFeedback extends StatefulWidget {
  _OpinionFeedbackState createState() => _OpinionFeedbackState();
}

class _OpinionFeedbackState extends State<OpinionFeedback> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
  }

  Future<void> releaseFeedbackCallback() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      String content = _textEditingController.text;
      if (content == '') {
        Toast.show(
          '内容不能为空',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        return;
      }
      var result = await releaseFeedback(
        userid: userModel.userid,
        feedbackContent: content,
      );
      if (result['noerr'] == 0) {
        _textEditingController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                '写下您的问题或建议',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: _textEditingController,
              maxLines: 7,
              maxLength: 150,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: '我们会非常重视您提出的宝贵的建议。',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ),
            GestureDetector(
              onTap: releaseFeedbackCallback,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    '提交',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
