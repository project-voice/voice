import 'package:flutter/material.dart';
import 'package:voice/model/MessageModel.dart';

class MessageItem extends StatelessWidget {
  final MessageModel messageModel;
  MessageItem({Key key, this.messageModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Text(
            messageModel.createTime,
            style: TextStyle(color: Colors.grey),
          ),
          Container(
              width: screenWidth,
              margin: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(0.0, 4.0),
                      blurRadius: 4,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]),
                      ),
                    ),
                    child: Text(
                      messageModel.messageTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messageModel.messageContent,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
