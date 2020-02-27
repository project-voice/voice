import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class EmailCheck extends StatefulWidget {
  _EmailCheckState createState() => _EmailCheckState();
}

class _EmailCheckState extends State<EmailCheck> {
  TextEditingController _emialControoler;
  TextEditingController _identityCode;
  GlobalKey _formKey;
  Map titleInfo = {
    'register': {
      'title': '注册',
      'subTitle': '请输入您的邮箱，用于注册您的账号',
      'nextPage': 'register'
    },
    'forgetPassword': {
      'title': '找回密码',
      'subTitle': '请输入您的邮箱，用于找回您的密码',
      'nextPage': 'newPassword'
    },
  };
  bool isSend = false;
  int countDown = 60;
  Timer _timer;
  final String regexEmail =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  String _email;

  @override
  void initState() {
    super.initState();
    // 初始化Controller
    _emialControoler = TextEditingController();
    _identityCode = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _emialControoler?.dispose();
    _identityCode?.dispose();
    cancelTimer();
  }

  /// 验证是否是email格式
  bool isEmail(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  /// 开启定时器
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countDown--;
      });
      if (countDown == 0) {
        cancelTimer();
        setState(() {
          countDown = 60;
          isSend = false;
        });
      }
    });
  }

  /// 关闭定时器
  void cancelTimer() {
    _timer?.cancel();
  }

  // 验证邮箱格式，调后端接口发送验证码，60秒倒计时。
  void sendEmailCallback() async {
    if (isSend) return;
    if (isEmail(_email)) {
      // 掉后端接口发送验证码
      bool result = await sendEmail();
      if (result) {
        // 开启倒计时
        startTimer();
        setState(() {
          isSend = true;
        });
      }
    } else {
      Toast.show(
        '邮箱格式不正确',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
    }
  }

  // 调邮箱发送验证码请求
  Future<bool> sendEmail() async {
    try {
      var arguments = ModalRoute.of(context).settings.arguments;
      var result = await emailIdentity(userEmail: _email, type: arguments);
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
      );
      if (result['noerr'] == 0) {
        return true;
      }
    } catch (err) {
      print(err);
    }
    return false;
  }

  // 验证验证码是否正确
  Function checkIdentityCallback(nextPage) {
    return () async {
      // 1、发送请求验证验证码是否正确
      // 2、如果正确跳转到修改密码界面
      try {
        String identity = _identityCode.text;
        var result = await checkIdentity(
          userEmail: _email,
          identity: identity,
        );
        if (result['noerr'] == 0) {
          Future.delayed(Duration(seconds: 1)).then((value) {
            Navigator.of(context).pushNamed(nextPage, arguments: _email);
          });
        }
        Toast.show(
          result['message'],
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      } catch (err) {
        print(err);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    var arguments = ModalRoute.of(context).settings.arguments;
    String title = titleInfo[arguments]['title'];
    String subTitle = titleInfo[arguments]['subTitle'];
    String nextPage = titleInfo[arguments]['nextPage'];
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(subTitle),
              Container(
                height: 60,
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: _emialControoler,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: '邮箱',
                    hintText: '请输入邮箱',
                    prefixIcon: Icon(Icons.email),
                    suffix: GestureDetector(
                      onTap: sendEmailCallback,
                      child: Text(
                        countDown == 60 ? '发送验证码' : countDown.toString(),
                        style: TextStyle(
                          color: isSend ? Colors.grey : Colors.orange,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: _identityCode,
                  decoration: InputDecoration(
                    labelText: '验证码',
                    hintText: '请输入验证码',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("下一步"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: checkIdentityCallback(nextPage),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
