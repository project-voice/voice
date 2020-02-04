enum ActionTypes {
  Increment,
  UpdateHomeSelectedTab,
  VideoSupport,
  VideoShare,
  EnglishCornerLoad,
  EnglishCornerRefresh,
  EnglishCornerSupport,
  EnglishCornerComment,

  // 登录
  Login
}

Map<String, dynamic> createActionHandler(dynamic type, dynamic data) {
  return {'type': type, 'data': data};
}
