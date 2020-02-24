class MessageModel extends Object {
  int messageid;
  int userid;
  String messageContent;
  String messageTitle;
  String createTime;
  MessageModel({
    this.userid,
    this.messageid,
    this.messageContent,
    this.messageTitle,
    this.createTime,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      userid: json['user_id'] as int,
      messageid: json['message_id'] as int,
      messageContent: json['message_content'] as String,
      messageTitle: json['message_title'] as String,
      createTime: json['create_time'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': userid,
      'message_id': messageid,
      'message_content': messageContent,
      'message_title': messageTitle,
      'create_time': createTime,
    };
  }
}
