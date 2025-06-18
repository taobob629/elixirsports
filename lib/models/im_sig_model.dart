class ImSigModel {
  late String token;
  late String uid;

  ImSigModel();

  ImSigModel.fromJson(Map<String, dynamic> json) {
    token = json["token"] ?? "";
    uid = json["uid"] ?? "";
  }
}
