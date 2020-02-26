class UserModel extends Object {
  int userid;
  String userName;
  String userPassword;
  String userEmail;
  String userDescription;
  String userSex;
  String userBirthday;
  String userImage;
  String createTime;
  UserModel({
    this.userid,
    this.userPassword,
    this.userEmail,
    this.userDescription,
    this.userSex,
    this.userBirthday,
    this.userImage,
    this.userName,
    this.createTime,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json['user_sex']);
    return UserModel(
      userid: json['user_id'] as int,
      userPassword: json['user_password'] as String,
      userEmail: json['user_email'] as String,
      userDescription: json['user_description'] as String,
      userSex: json['user_sex'] as String,
      userBirthday: json['user_birthday'] as String,
      userImage: json['user_image'] as String,
      userName: json['user_name'] as String,
      createTime: json['create_time'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userid,
      'user_password': userPassword,
      'user_email': userEmail,
      'user_description': userDescription,
      'user_sex': userSex,
      'user_birthday': userBirthday,
      'user_image': userImage,
      'user_name': userName,
      'create_time': createTime,
    };
  }
}
