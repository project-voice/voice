class StageModel extends Object {
  int stageId;
  int stageNum;
  String stageTitle;
  String stageBanner;
  String stageDescription;
  String stageTag;
  bool lock;
  num complete;
  int userCount;
  StageModel({
    this.lock,
    this.complete,
    this.stageBanner,
    this.stageDescription,
    this.stageId,
    this.stageNum,
    this.stageTag,
    this.stageTitle,
    this.userCount,
  });
  factory StageModel.formJson(Map<String, dynamic> json) {
    return StageModel(
      stageId: json['stage_id'] as int,
      stageBanner: json['stage_banner'] as String,
      stageDescription: json['stage_description'] as String,
      stageNum: json['stage_num'] as int,
      stageTag: json['stage_tag'] as String,
      stageTitle: json['stage_title'] as String,
      lock: json['lock'] as bool,
      complete: json['complete'] as num,
      userCount: json['userCount'] as int,
    );
  }
}
