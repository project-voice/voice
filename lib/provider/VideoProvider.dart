import 'package:flutter/material.dart';
import 'package:voice/model/VideoModel.dart';

class VideoProvider with ChangeNotifier {
  List<VideoModel> followList;
  List<VideoModel> recommendList;
  VideoProvider() {
    followList = [];
    recommendList = [];
  }
  initVideoList(Map<String, dynamic> json) {
    List follow = json['follow'] as List;
    List recommend = json['recommend'] as List;
    followList = follow.map((video) {
      return VideoModel.fromJSON(video);
    }).toList();
    recommendList = recommend.map((video) {
      return VideoModel.fromJSON(video);
    }).toList();

    notifyListeners();
  }

  addVideoList(String type, List<Map> json) {
    List<VideoModel> nextList = json.map((video) {
      return VideoModel.fromJSON(video);
    }).toList();
    if (type == 'follow') {
      followList.addAll(nextList);
    }
    recommendList.addAll(nextList);
    notifyListeners();
  }

  updateSupport(String type, int videoIdx, Map<String, dynamic> supportJson) {
    Support support = Support.fromJson(supportJson);
    List<VideoModel> tempList = type == 'follow' ? followList : recommendList;
    tempList[videoIdx].support = support;
    notifyListeners();
  }

  updateComment(String type, int videoIdx, int comment) {
    List<VideoModel> tempList = type == 'follow' ? followList : recommendList;
    tempList[videoIdx].comment = comment;
    notifyListeners();
  }

  updateShare(String type, int videoIdx, int share) {
    List<VideoModel> tempList = type == 'follow' ? followList : recommendList;
    tempList[videoIdx].videoShare = share;
    notifyListeners();
  }

  updateFollow(int followid) {
    recommendList = recommendList.map((videoInfo) {
      if (videoInfo.userid == followid) {
        videoInfo.follow = true;
      }
      return videoInfo;
    }).toList();
    notifyListeners();
  }
}
