import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class Description extends StatefulWidget {
  final UserModel userModel;
  Description({Key key, this.userModel}) : super(key: key);
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController _textEditingController;
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.userModel.userDescription,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
  }

  void updateDescription() {
    setState(() {
      isEdit = true;
    });
  }

  Future<void> submitNewDescription() async {
    try {
      String value = _textEditingController.text;
      if (value == '') {
        Toast.show(
          '简介不能为空',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        return;
      }
      var result = await updateUserInfo(
        userid: widget.userModel.userid,
        key: 'user_description',
        value: value,
      );
      if (result['noerr'] == 0) {
        await Provider.of<UserProvider>(context, listen: false).setUserMessage(
          'description',
          value,
        );
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
      setState(() {
        isEdit = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: updateDescription,
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '简介：',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.7,
                    child: isEdit
                        ? TextField(
                            controller: _textEditingController,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffix: GestureDetector(
                                onTap: submitNewDescription,
                                child: Text(
                                  '提交',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red[400],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            widget.userModel.userDescription,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            isEdit
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isEdit = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[400],
                    ),
                  )
                : Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey[400],
                  ),
          ],
        ),
      ),
    );
  }
}
