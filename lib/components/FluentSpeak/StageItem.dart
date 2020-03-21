import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/model/StageModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class StageItem extends StatefulWidget {
  final StageModel stageModel;
  StageItem({Key key, this.stageModel}) : super(key: key);
  _StageItemState createState() => _StageItemState();
}

class _StageItemState extends State<StageItem> {
  void jumpQuestionDetails() {
    print('答题');
    UserModel userModel = Provider.of<UserProvider>(
      context,
      listen: false,
    ).userInfo;
    if (userModel.userid == 0) {
      Navigator.of(context).pushNamed('login');
      return;
    }
    if (widget.stageModel.lock) {
      Toast.show(
        '请先完成前面阶段的题目',
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
      return;
    }
    Navigator.of(context).pushNamed(
      'questionDetails',
      arguments: widget.stageModel.stageNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: jumpQuestionDetails,
      child: Container(
        margin: EdgeInsets.only(top: 12),
        width: screenWidth,
        height: 110,
        padding: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: Colors.grey[200],
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: widget.stageModel.stageBanner,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        color: widget.stageModel.lock
                            ? Color.fromARGB(120, 0, 0, 0)
                            : Color.fromARGB(0, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: widget.stageModel.lock
                            ? Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 30,
                              )
                            : SizedBox(
                                height: 70,
                                width: 70,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  value: widget.stageModel.complete.toDouble(),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: widget.stageModel.lock
                        ? Container()
                        : Container(
                            width: 80,
                            height: 100,
                            child: Center(
                              child: Text(
                                '${widget.stageModel.complete * 100}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.stageModel.stageTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: screenWidth - 140,
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          widget.stageModel.stageDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.stageModel.stageTag,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Text(
                          '${widget.stageModel.userCount}人学习',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
