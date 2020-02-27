import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController _newPasswordController;
  GlobalKey _formKey;
  bool hidePassword = true;
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
                    hintText: '请输入新密码',
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
                  validator: (value) {
                    return null;
                  },
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
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            // 登录发起请求，登录成功之后获取到用户信息存入Store,然后跳转到首页。
                            // 1、发起请求
                            // 2、请求回来之后用户信息写入store
                            // dispatch();
                          }
                        },
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
