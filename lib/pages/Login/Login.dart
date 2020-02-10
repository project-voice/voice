import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:voice/store/action/action.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  GlobalKey _formKey;
  bool hidePassword = true;
  RegExp passRegexp =
      RegExp('(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{8,30}');

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  bool regexpPassword(input) {
    if (input == null || input.isEmpty) return false;
    return passRegexp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
          centerTitle: true,
        ),
        body: Container(
            width: screenWidth,
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  labelText: '用户名',
                                  hintText: '用户名或邮箱',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                              validator: (value) {
                                bool isEmpty = value.trim().length == 0;
                                if (isEmpty) {
                                  return '用户名或邮箱不能为空！';
                                }
                                return null;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          margin: EdgeInsets.only(top: 8),
                          child: TextFormField(
                              controller: _passwordController,
                              obscureText: hidePassword,
                              decoration: InputDecoration(
                                  labelText: '密码',
                                  hintText: '请输入您的密码',
                                  prefixIcon: Icon(Icons.lock),
                                  suffix: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      size: 20,
                                      color: hidePassword
                                          ? Colors.grey
                                          : Colors.orange,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                              validator: (value) {
                                if (!regexpPassword(value)) {
                                  return '密码格式不正确';
                                }
                                return null;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: StoreConnector(converter: (store) {
                                return (data) => store.dispatch(
                                    createActionHandler(
                                        ActionTypes.Login, data));
                              }, builder: (context, loginDispatch) {
                                return RaisedButton(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("登录"),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if ((_formKey.currentState as FormState)
                                        .validate()) {
                                      // 登录发起请求，登录成功之后获取到用户信息存入Store,然后跳转到首页。
                                      // 1、发起请求
                                      // 2、请求回来之后用户信息写入store
                                      // loginDispatch();
                                    }
                                  },
                                );
                              })),
                            ],
                          ),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('emailCheck',
                                  arguments: 'register');
                            },
                            child: Text('注册',
                                style: TextStyle(color: Colors.orange))),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('emailCheck',
                                  arguments: 'forgetPassword');
                            },
                            child: Text('找回密码',
                                style: TextStyle(color: Colors.red)))
                      ],
                    ))
              ],
            )));
  }
}
