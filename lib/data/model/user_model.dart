class UserModel {
  int userId;
  String name;
  String bankName;
  String branchName;
  String pin;
  String branchAddress;
  String status;
  bool isAdmin;
  String lat;
  String lng;
  UserModel(
      {required this.pin,
      required this.userId,
      required this.name,
      required this.branchAddress,
      required this.branchName,
      required this.bankName,
      required this.status,
      required this.lng,
      required this.lat,
      required this.isAdmin});

  factory UserModel.fromJson(Map<String, dynamic> _json) {
    return UserModel(
        pin: _json['pin'] ?? '',
        userId: _json['eid'] ?? 0,
        name: _json['name'] ?? '',
        bankName: _json['bankName'] ?? '',
        branchName: _json['branchName'] ?? '',
        branchAddress: _json['branchAddress'] ?? '',
        status: _json['status'] ?? '',
        lat: _json['lat'] ?? '',
        lng: _json['lng'] ?? '',
        isAdmin: _json['isAdmin'] ?? false);
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['id'] = userId;
    map['pin'] = pin;
    map['name'] = name;
    map['mobile'] = bankName;
    map['email'] = branchName;
    map['branchAddress'] = branchAddress;
    map['isAdmin'] = isAdmin;
    map['isAdmin'] = isAdmin;
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}

class LoggedInUserModel {
  LoggedInUserModel({
    required this.id,
    required this.roleID,
    required this.areaID,
    required this.channelID,
    required this.fullName,
    required this.phoneNo,
    required this.responseCode,
    required this.responseMessage,
    required this.token,
  });
  final int id;
  final int roleID;
  final int areaID;
  final int channelID;
  final String fullName;
  final String phoneNo;
  final int responseCode;
  final String responseMessage;
  final String token;

  factory LoggedInUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedInUserModel(
      id: json['id'],
      roleID: json['roleID'],
      areaID: json['areaID'],
      channelID: json['channelID'],
      fullName: json['fullName'],
      phoneNo: json['phoneNo'],
      responseCode: json['responseCode'],
      responseMessage: json['responseMessage'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['roleID'] = roleID;
    _data['areaID'] = areaID;
    _data['channelID'] = channelID;
    _data['fullName'] = fullName;
    _data['phoneNo'] = phoneNo;
    _data['responseCode'] = responseCode;
    _data['responseMessage'] = responseMessage;
    _data['token'] = token;
    return _data;
  }
}
