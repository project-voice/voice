import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emialControoler;
  TextEditingController _newPasswordController;
  GlobalKey _formKey;
  @override
  void initState() {
    super.initState();
    _emialControoler = TextEditingController();
    _newPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _emialControoler.dispose();
    _newPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('找回密码'),
          centerTitle: true,
        ),
        body: Container(
            width: screenWidth,
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                       
                    )
                  ],
                ))));
  }
}
