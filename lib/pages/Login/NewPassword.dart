import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';

class NewPassword extends StatefulWidget {
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _newPasswordController;
  GlobalKey _formKey;
  bool hidePassword = true;
  RegExp passRegexp =
      RegExp('(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{8,30}');
  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordController?.dispose();
  }

  bool regexpPassword(input) {
    if (input == null || input.isEmpty) return false;
    return passRegexp.hasMatch(input);
  }

  Future<void> updatePassword() async {
    try {
      String password = _newPasswordController.text;
      if (!regexpPassword(password)) {
        Toast.show(
          '密码格式不正确，必须包括：数字、字母大小写、特殊符号且长度大于8位。',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
        return;
      }
      Map arguments = ModalRoute.of(context).settings.arguments;
      var result = await updateUserInfo(
        userid: arguments['userid'],
        key: 'user_password',
        value: password,
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
        duration: Toast.LENGTH_LONG,
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
        title: Text('新密码'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('请输入新密码，用于新的登录密码'),
              Container(
                height: 58,
                margin: EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: _newPasswordController,
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
                      child: Container(
                        width: 30,
                        height: 60,
                        child: Center(
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: hidePassword ? Colors.grey : Colors.orange,
                          ),
                        ),
                      ),
                    ),
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
                        padding: EdgeInsets.all(16.0),
                        child: Text("更新密码",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: updatePassword,
                      ),
                    ),
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
