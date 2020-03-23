import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/model/StageModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';
import 'package:voice/routes/Application.dart';
import 'package:voice/routes/Routes.dart';

class SpeakInfo extends StatelessWidget {
  final List<StageModel> stageList;
  SpeakInfo({Key key, this.stageList}) : super(key: key);

  Function jumpQuestionDetails(BuildContext context, StageModel stageModel) {
    return () {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      if (userModel.userid == 0) {
        Application.router.navigateTo(
          context,
          Routes.loginPage,
          transition: TransitionType.native,
        );
        return;
      }
      if (stageModel.lock) {
        Toast.show(
          '请先完成前面阶段的题目',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
        return;
      }
      Application.router.navigateTo(
        context,
        '${Routes.questionDetalsPage}?stageNum=${stageModel.stageNum}',
        transition: TransitionType.native,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .5,
            color: Colors.grey[200],
          ),
        ),
      ),
      width: screenWidth,
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '流利说',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            height: 140,
            margin: EdgeInsets.only(top: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: jumpQuestionDetails(context, stageList[index]),
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  width: 100,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  imageUrl: stageList[index].stageBanner,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: stageList[index].lock
                                        ? Color.fromARGB(120, 0, 0, 0)
                                        : Color.fromARGB(0, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: stageList[index].lock
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
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                              value: stageList[index]
                                                  .complete
                                                  .toDouble(),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: stageList[index].lock
                                    ? Container()
                                    : Container(
                                        width: 100,
                                        height: 120,
                                        child: Center(
                                          child: Text(
                                            '${stageList[index].complete * 100}%',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          stageList[index].stageTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
