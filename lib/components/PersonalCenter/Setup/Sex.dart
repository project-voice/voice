import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class Sex extends StatefulWidget {
  final UserModel userModel;
  Sex({Key key, this.userModel}) : super(key: key);
  _SexState createState() => _SexState();
}

class _SexState extends State<Sex> {
  bool isEdit = false;
  bool _switchSelected = false;
  @override
  void initState() {
    super.initState();
    if (widget.userModel.userSex == '男') {
      _switchSelected = false;
    } else {
      _switchSelected = true;
    }
  }

  void updateSex() {
    setState(() {
      isEdit = true;
    });
  }

  Future<void> switchHander(selected) async {
    try {
      int value = 0;
      String text = '男';
      if (selected) {
        value = 1;
        text = '女';
      }
      var result = await updateUserInfo(
        userid: widget.userModel.userid,
        key: 'user_sex',
        value: value,
      );
      if (result['noerr'] == 0) {
        await Provider.of<UserProvider>(context, listen: false).setUserMessage(
          'sex',
          text,
        );
      }
      setState(() {
        _switchSelected = selected;
        isEdit = false;
      });
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: updateSex,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
          ),
        ),
        padding: EdgeInsets.only(left: 16, right: 16),
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
                    '性别：',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.7,
                    child: isEdit
                        ? Row(
                            children: <Widget>[
                              Text('男'),
                              Switch(
                                value: _switchSelected,
                                activeColor: Colors.red,
                                inactiveThumbColor: Colors.blue,
                                onChanged: switchHander,
                              ),
                              Text('女'),
                            ],
                          )
                        : Text(
                            widget.userModel.userSex,
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
