import 'dart:async';

import 'package:flutter/material.dart';

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
    // 页面卸载将Controller销毁掉
    _emialControoler.dispose();
    _identityCode.dispose();
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
                                onTap: () {
                                  // 验证邮箱格式，调后端接口发送验证码，60秒倒计时。
                                  if (isSend) return;
                                  if (isEmail(_email)) {
                                    startTimer();
                                    setState(() {
                                      isSend = true;
                                    });
                                  } else {
                                    print('邮箱格式错误');
                                  }
                                },
                                child: Text(
                                  countDown == 60
                                      ? '发送验证码'
                                      : countDown.toString(),
                                  style: TextStyle(
                                    color: isSend ? Colors.grey : Colors.orange,
                                  ),
                                )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
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
                            )),
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
                            onPressed: () {
                              // 1、发送请求验证验证码是否正确
                              // 2、如果正确跳转到修改密码界面
                              Navigator.of(context).pushNamed(nextPage);
                            },
                          ))
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
