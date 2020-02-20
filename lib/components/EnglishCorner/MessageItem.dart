import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

class MessageItem extends StatefulWidget {
  final Map content;
  final TabController controller;
  MessageItem({Key key, this.content, this.controller}) : super(key: key);
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  Function topicHandler(List topics) {
    num index = topics.indexOf(widget.content['topic']);
    return () {
      widget.controller.index = index;
    };
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  width: 40,
                  height: 40,
                  imageUrl: widget.content['image'],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(widget.content['author'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(widget.content['time'],
                        style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.content['content']['text'],
                    style: TextStyle(
                      fontSize: 16,
                    )),
                imageLayout(screenWidth)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 10),
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                '#' + widget.content['topic'],
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.chat,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2),
                      child: Text(
                        widget.content['comment'].toString(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.thumb_up,
                        size: 20,
                        color: widget.content['support']['action']
                            ? Colors.orange[400]
                            : Colors.grey[400],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2),
                      child: Text(
                        widget.content['support']['count'].toString(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 图片布局
  Widget imageLayout(double screenWidth) {
    List images = widget.content['content']['images'];
    double width;
    if (images.length == 1) {
      width = (screenWidth / 2).floorToDouble() - 50;
    } else if (images.length <= 4) {
      width = (screenWidth / 2).floorToDouble() - 50;
    } else {
      width = (screenWidth / 3).floorToDouble() - 50;
    }
    List<Widget> imageWidgets = images.map((url) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: width,
            fit: BoxFit.cover,
            imageUrl: url,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ));
    }).toList();

    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        children: imageWidgets,
      ),
    );
  }
}
