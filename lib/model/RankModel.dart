class RankModel extends Object {
  int index;
  int count;
  int userId;
  String userName;
  String userImage;
  RankModel({
    this.index,
    this.count,
    this.userId,
    this.userImage,
    this.userName,
  });
  factory RankModel.formJson(Map<String, dynamic> json) {
    return RankModel(
      index: json['index'] as int,
      count: json['num'] as int,
      userId: int.parse(json['user_id']),
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String,
    );
  }
}
