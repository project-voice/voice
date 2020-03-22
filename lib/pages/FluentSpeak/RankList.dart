import 'package:flutter/material.dart';
import 'package:voice/api/Answer.dart';
import 'package:voice/model/RankModel.dart';
import 'package:voice/components/FluentSpeak/RankItem.dart';

class RankList extends StatefulWidget {
  _RankListState createState() => _RankListState();
}

class _RankListState extends State<RankList> {
  List<RankModel> rankList;
  @override
  void initState() {
    super.initState();
    fetchRequest();
  }

  Future<void> fetchRequest() async {
    try {
      var result = await getIndexRankAll();
      if (result['noerr'] == 0) {
        List<RankModel> tempList = result['data']
            .map((item) {
              return RankModel.formJson(item);
            })
            .cast<RankModel>()
            .toList();
        setState(() {
          rankList = tempList;
        });
      } else {
        print('加载失败');
      }
      print(result);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('积分榜单'),
        centerTitle: true,
      ),
      body: rankList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : rankList.isEmpty
              ? Center(
                  child: Text('目前还未有人学习'),
                )
              : Container(
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: rankList.length,
                    itemBuilder: (context, index) {
                      return RankItem(rankModel: rankList[index], rank: index);
                    },
                  ),
                ),
    );
  }
}
