class AdModel {
  String title = '';
  String content = '';
  String image = '';
  String type = '';
  String target = '';

  AdModel();

  AdModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    content = json['content'] ?? '';
    image = json['image'] ?? '';
    type = json['type'] ?? '';
    target = json['target'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image': image,
      'target': target,
      'type': type,
    };
  }
}
