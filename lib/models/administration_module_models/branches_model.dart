import 'dart:convert';

class BranchesModel {
  final dynamic branchId;
  final dynamic branchName;
  final dynamic branchTitle;
  final dynamic branchPhone;
  final dynamic branchAddress;
  final dynamic branchSales;
  final dynamic isProduction;
  final dynamic addDate;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;

  BranchesModel({
    required this.branchId,
    required this.branchName,
    required this.branchTitle,
    required this.branchPhone,
    required this.branchAddress,
    required this.branchSales,
    required this.isProduction,
    required this.addDate,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
  });

  factory BranchesModel.fromJson(String str) => BranchesModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory BranchesModel.fromMap(Map<String, dynamic> json) => BranchesModel(
    branchId: json["branch_id"],
    branchName: json["Branch_name"],
    branchTitle: json["Branch_title"],
    branchPhone: json["Branch_phone"],
    branchAddress: json["Branch_address"],
    branchSales: json["Branch_sales"],
    isProduction: json["is_production"],
    addDate: json["add_date"],
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
    "branch_id": branchId,
    "Branch_name": branchName,
    "Branch_title": branchTitle,
    "Branch_phone": branchPhone,
    "Branch_address": branchAddress,
    "Branch_sales": branchSales,
    "is_production": isProduction,
    "add_date": addDate,
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
