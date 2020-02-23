import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice/model/UserModel.dart';

class UserProvider extends ChangeNotifier {
  UserModel userInfo = UserModel(userid: 0);
  List<UserModel> followList;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserProvider() {
    followList = [];
    this.getUserInfoFromShare().then((user) {
      userInfo = user;
      notifyListeners();
    });
  }

  Future<UserModel> getUserInfoFromShare() async {
    // 从share中获取用户信息，没有的话创建一个id为0的UserModel，
    SharedPreferences prefs = await _prefs;
    String userJson = prefs.getString('user');
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return UserModel(userid: 0);
  }

  updateUserInfo(Map<String, dynamic> json) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('user', jsonEncode(json));
    userInfo = UserModel.fromJson(json);
    notifyListeners();
  }

  setFollowList(List<Map> jsons) {
    followList = jsons.map((json) {
      return UserModel.fromJson(json);
    }).toList();
    notifyListeners();
  }

  setUserMessage(String key, String value) {
    switch (key) {
      case 'name':
        userInfo.userName = value;
        notifyListeners();
        return;
      case 'password':
        userInfo.userPassword = value;
        notifyListeners();
        return;
      case 'description':
        userInfo.userDescription = value;
        notifyListeners();
        return;
      case 'sex':
        userInfo.userSex = value;
        notifyListeners();
        return;
      case 'birthday':
        userInfo.userBirthday = value;
        notifyListeners();
        return;
      case 'image':
        userInfo.userImage = value;
        notifyListeners();

        return;
      default:
        return;
    }
  }
}
