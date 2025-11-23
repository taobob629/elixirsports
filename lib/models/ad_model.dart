class AdModel {
  String title = '';
  String content = '';
  String image = '';
  String type = '';
  String target = '';
  String msg='';
  String id='';

  AdModel();

  AdModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    content = json['content'] ?? '';
    image = json['image'] ?? '';
    type = json['type'] ?? '';
    target = json['target'] ?? '';
    msg = json['msg'] ?? '';
    id = json['id'] ?? '';

  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image': image,
      'target': target,
      'type': type,
      'msg': msg,
      'id': id,

    };
  }
}
