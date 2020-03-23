import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Stage.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/BaseInfo.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/SpeakInfo.dart';
import 'package:voice/components/PersonalCenter/PersonalPage/TopicAndVideoInfo.dart';
import 'package:voice/model/StageModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  List<StageModel> stageList = [];
  @override
  void initState() {
    super.initState();
    getStageRequest();
  }

  Future<void> getStageRequest() async {
    try {
      UserModel userModel = Provider.of<UserProvider>(
        context,
        listen: false,
      ).userInfo;
      var result = await getStageList(
        userId: userModel.userid,
      );
      if (result['noerr'] == 0) {
        List<StageModel> tempList = result['data']
            .map((item) {
              return StageModel.formJson(item);
            })
            .cast<StageModel>()
            .toList();
        setState(() {
          stageList = tempList;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    num screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF5B86E5),
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16, top: 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BaseInfo(),
                      Container(
                        width: screenWidth,
                        height: 20,
                        color: Colors.grey[100],
                      ),
                      SpeakInfo(stageList: stageList),
                      TopicAndVideoInfo(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 85,
              left: 30,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 70,
                    height: 70,
                    imageUrl:
                        'http://kimvoice.oss-cn-beijing.aliyuncs.com/voice/user/2020-03-20%2018%3A25%3A34.527413.jpg',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
