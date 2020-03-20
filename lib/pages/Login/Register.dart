import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';

class Register extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
    _usernameController?.dispose();
    _passwordController?.dispose();
  }

  String usernameValidator(value) {
    bool isEmpty = value.trim().length == 0;
    if (isEmpty) {
      return '邮箱不能为空！';
    }
    return null;
  }

  bool regexpPassword(input) {
    if (input == null || input.isEmpty) return false;
    return passRegexp.hasMatch(input);
  }

  String passwordValidator(value) {
    if (!regexpPassword(value)) {
      return '密码格式不正确';
    }
    return null;
  }

  Future<void> registerAction() async {
    if ((_formKey.currentState as FormState).validate()) {
      try {
        Map arguments = ModalRoute.of(context).settings.arguments;
        var result = await register(
          userName: _usernameController.text,
          userPassword: _passwordController.text,
          userEmail: arguments['email'],
        );
        if (result['noerr'] == 0) {
          Future.delayed(Duration(seconds: 1)).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
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
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
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
                        hintText: '请输入用户名',
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
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
                        hintText: '包括：数字、字母大小写、特殊符号且长度大于8位',
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
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
                            onPressed: registerAction,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
