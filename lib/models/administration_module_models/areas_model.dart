import 'dart:convert';

class AreasModel {
  final dynamic districtSlNo;
  final dynamic districtName;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;

  AreasModel({
    required this.districtSlNo,
    required this.districtName,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
  });

  factory AreasModel.fromJson(String str) => AreasModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory AreasModel.fromMap(Map<String, dynamic> json) => AreasModel(
    districtSlNo: json["District_SlNo"],
    districtName: json["District_Name"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
  );

  Map<String, dynamic> toMap() => {
    "District_SlNo": districtSlNo,
    "District_Name": districtName,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
  };
}
