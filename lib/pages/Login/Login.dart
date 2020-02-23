import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/provider/UserProvider.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey _formKey;
  bool hidePassword = true;
  RegExp passRegexp =
      RegExp('(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{8,30}');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
  }

  bool regexpPassword(input) {
    if (input == null || input.isEmpty) return false;
    return passRegexp.hasMatch(input);
  }

  String usernameValidator(value) {
    bool isEmpty = value.trim().length == 0;
    if (isEmpty) {
      return '邮箱不能为空！';
    }
    return null;
  }

  String passwordValidator(value) {
    // if (!regexpPassword(value)) {
    //   return '密码格式不正确';
    // }
    return null;
  }

  void loginAction() async {
    if ((_formKey.currentState as FormState).validate()) {
      try {
        UserProvider userProvider = Provider.of<UserProvider>(
          context,
          listen: false,
        );
        String userEmail = _emailController.text;
        String password = _passwordController.text;
        var result = await login(
          userEmail: userEmail,
          userPassword: password,
        );
        if (result['noerr'] == 0) {
          // 登录成功
          await userProvider.updateUserInfo(result['data']);
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.of(context).pop();
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
    }
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: '邮箱',
                          hintText: '请输入邮箱',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: usernameValidator,
                      ),
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
                              color: hidePassword ? Colors.grey : Colors.orange,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: passwordValidator,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              child: Text("登录"),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: loginAction,
                            ),
                          ),
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
                      Navigator.of(context)
                          .pushNamed('emailCheck', arguments: 'register');
                    },
                    child: Text(
                      '注册',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('emailCheck', arguments: 'forgetPassword');
                    },
                    child: Text(
                      '找回密码',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
