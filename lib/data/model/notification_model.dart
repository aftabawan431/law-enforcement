class NotificationModel {
  NotificationModel({
    required this.statusCode,
    required this.statusMessage,
    required this.emergencyID,
    required this.managerName,
    required this.bankName,
    required this.branchName,
    required this.clickaction,
    required this.address,
    required this.Lat,
    required this.Lng,
  });
  late final int statusCode;
  late final String statusMessage;
  late final int emergencyID;
  late final String managerName;
  late final String bankName;
  late final String branchName;
  late final String clickaction;
  late final String address;
  late final String Lat;
  late final String Lng;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? 0;
    statusMessage = json['statusMessage'] ?? '';
    emergencyID = json['emergencyID'] ?? 0;
    managerName = json['managerName'] ?? '';
    bankName = json['bankName'] ?? '';
    branchName = json['branchName'] ?? '';
    clickaction = json['click_action'] ?? '';
    address = json['address'] ?? '';
    Lat = json['Lat'] ?? '';
    Lng = json['Lng'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['statusMessage'] = statusMessage;
    _data['emergencyID'] = emergencyID;
    _data['managerName'] = managerName;
    _data['bankName'] = bankName;
    _data['branchName'] = branchName;
    _data['click_action'] = clickaction;
    _data['address'] = address;
    _data['Lat'] = Lat;
    _data['Lng'] = Lng;
    return _data;
  }
}
