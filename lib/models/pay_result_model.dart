class PayResultModel {
  int status;
  String notifyMsg;

  PayResultModel({
    required this.status,
    required this.notifyMsg,
  });

  factory PayResultModel.fromJson(Map<String, dynamic> json) => PayResultModel(
        status: json["status"] ?? 0,
        notifyMsg: json["notifyMsg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "notifyMsg": notifyMsg,
      };
}
