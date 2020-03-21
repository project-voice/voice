import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice/api/Stage.dart';
import 'package:voice/components/FluentSpeak/StageItem.dart';
import 'package:voice/model/StageModel.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

class FluentSpeak extends StatefulWidget {
  _FluentSpeakState createState() => _FluentSpeakState();
}

class _FluentSpeakState extends State<FluentSpeak> {
  List<StageModel> stageList;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('流利说'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: stageList == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: stageList.length,
                itemBuilder: (context, index) {
                  return StageItem(stageModel: stageList[index]);
                },
              ),
      ),
    );
  }
}
