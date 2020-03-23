class VideoModel extends Object {
  int videoid;
  int userid;
  String videoUrl;
  String videoDescription;
  String videoBanner;
  int videoShare;
  String createTime;
  String userName;
  String userImage;
  int comment;
  bool follow;
  Support support;
  VideoModel({
    this.videoid,
    this.userid,
    this.videoUrl,
    this.videoDescription,
    this.videoBanner,
    this.videoShare,
    this.createTime,
    this.userName,
    this.userImage,
    this.comment,
    this.follow,
    this.support,
  });
  factory VideoModel.fromJSON(Map<String, dynamic> json) {
    return VideoModel(
      videoid: json['video_id'] as int,
      userid: json['user_id'] as int,
      videoUrl: json['video_url'] as String,
      videoDescription: json['video_description'] as String,
      videoBanner: json['video_banner'] as String,
      videoShare: json['video_share'] as int,
      createTime: json['create_time'] as String,
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String,
      comment: json['comment'] as int,
      follow: json['follow'] as bool,
      support: Support.fromJson(json['support'] as Map),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'video_id': videoid,
      'user_id': userid,
      'video_url': videoUrl,
      'video_description': videoDescription,
      'video_banner': videoBanner,
      'video_share': videoShare,
      'create_time': createTime,
      'user_name': userName,
      'user_image': userImage,
      'comment': comment,
      'support': support.toJson()
    };
  }
}

class Support {
  bool action;
  int count;
  Support({this.action, this.count});
  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(action: json['action'] as bool, count: json['count'] as int);
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'action': action, 'count': count};
  }
}
