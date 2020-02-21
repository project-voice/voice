class CommentModel extends Object {
  int count;
  List<Comment> commentList;
  CommentModel({
    this.count,
    this.commentList,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      count: json['count'] as int,
      commentList: (json['list'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }
}

class Comment extends Object {
  int commentid;
  int releaseid;
  int userid;
  String commentContent;
  int topicid;
  String createTime;
  int commentType;
  String userName;
  String releaseName;
  String userImage;
  Comment({
    this.commentid,
    this.releaseid,
    this.userid,
    this.commentContent,
    this.topicid,
    this.createTime,
    this.commentType,
    this.userName,
    this.releaseName,
    this.userImage,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentid: json['comment_id'] as int,
      releaseid: json['release_id'] as int,
      userid: json['user_id'] as int,
      commentContent: json['comment_content'] as String,
      topicid: json['topic_id'] as int,
      createTime: json['create_time'] as String,
      commentType: json['comment_type'] as int,
      userName: json['user_name'] as String,
      releaseName: json['release_name'] as String,
      userImage: json['user_image'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'comment_id': commentid,
      'release_id': releaseid,
      'user_id': userid,
      'comment_content': commentContent,
      'topic_id': topicid,
      'create_time': createTime,
      'comment_type': commentType,
      'user_name': userName,
      'release_name': releaseName,
      'user_image': userImage,
    };
  }
}
