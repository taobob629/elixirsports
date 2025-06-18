class ProblemModel {
  int? id;
  String? name;
  String? createBy;
  String? createTime;
  String? updateBy;
  String? updateTime;
  String? deleted;
  String? content;
  dynamic keyword;
  int? click;
  int? language;

  ProblemModel({
    this.id,
    this.name,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.deleted,
    this.content,
    this.keyword,
    this.click,
    this.language,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) => ProblemModel(
        id: json["id"],
        name: json["name"],
        createBy: json["createBy"],
        createTime: json["createTime"],
        updateBy: json["updateBy"],
        updateTime: json["updateTime"],
        deleted: json["deleted"],
        content: json["content"],
        keyword: json["keyword"],
        click: json["click"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createBy": createBy,
        "createTime": createTime,
        "updateBy": updateBy,
        "updateTime": updateTime,
        "deleted": deleted,
        "content": content,
        "keyword": keyword,
        "click": click,
        "language": language,
      };
}
