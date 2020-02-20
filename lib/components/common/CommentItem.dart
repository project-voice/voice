import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voice/model/CommentModel.dart';

class CommentItem extends StatelessWidget {
  final CommentModel commentData;
  CommentItem({this.commentData});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  width: 35,
                  height: 35,
                  imageUrl: commentData.userImage,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      commentData.userName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      commentData.createTime,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 40, top: 4),
            child: Text(commentData.commentContent),
          ),
        ],
      ),
    );
  }
}
