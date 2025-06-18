class PrivacyModel {
  int? id;
  String? title;
  String? content;
  int? privacyType;
  int? privacyState;
  String? notes;
  String? createTime;

  PrivacyModel({
    this.id,
    this.title,
    this.content,
    this.privacyType,
    this.privacyState,
    this.notes,
    this.createTime,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) => PrivacyModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    privacyType: json["privacyType"],
    privacyState: json["privacyState"],
    notes: json["notes"],
    createTime: json["createTime"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "privacyType": privacyType,
    "privacyState": privacyState,
    "notes": notes,
    "createTime": createTime,
  };
}
