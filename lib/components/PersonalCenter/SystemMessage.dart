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
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      var result = await getMessageList(userid: userModel.userid);
      if (result['noerr'] == 0) {
        if (result['data'] == null) {
          Toast.show(
            result['message'],
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER,
          );
          return;
        }
        setState(() {
          messageList = result['data']
              .map((message) {
                return MessageModel.fromJson(message);
              })
              .cast<MessageModel>()
              .toList();
        });
      }
      print(result['message']);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('系统消息'),
        centerTitle: true,
      ),
      body: Container(
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
