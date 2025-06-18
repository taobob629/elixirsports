
class VersionModel {
  late String store;
  late bool upgrade;
  late bool force;
  late String intro;
  late String version;
  late bool status;
  late bool googleLogin;

  VersionModel();

  VersionModel.fromJson(Map<String, dynamic> json) {
    store = json['store'];
    upgrade = json['upgrade'];
    force = json['force'];
    intro = json['intro'];
    version = json['new'];
    status = json['status'] ?? false;
    googleLogin = json['googleLogin'] ?? false;
  }
}