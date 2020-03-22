import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/Message.dart';
import 'package:voice/components/PersonalCenter/MessageItem.dart';
import 'package:voice/model/MessageModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class SystemMessage extends StatefulWidget {
  _SystemMessageState createState() => _SystemMessageState();
}

class _SystemMessageState extends State<SystemMessage> {
  List<MessageModel> messageList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('系统消息'),
        centerTitle: true,
      ),
      body: messageList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return MessageItem(messageModel: messageList[index]);
                  }),
            ),
    );
  }
}
