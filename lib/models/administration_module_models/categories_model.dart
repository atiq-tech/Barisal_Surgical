import 'dart:convert';

class CategoriesModel {
  final dynamic productCategorySlNo;
  final dynamic productCategoryName;
  final dynamic productCategoryDescription;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;

  CategoriesModel({
    required this.productCategorySlNo,
    required this.productCategoryName,
    required this.productCategoryDescription,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
  });

  factory CategoriesModel.fromJson(String str) => CategoriesModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory CategoriesModel.fromMap(Map<String, dynamic> json) => CategoriesModel(
    productCategorySlNo: json["ProductCategory_SlNo"],
    productCategoryName: json["ProductCategory_Name"],
    productCategoryDescription: json["ProductCategory_Description"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
  );

  Map<String, dynamic> toMap() => {
    "ProductCategory_SlNo": productCategorySlNo,
    "ProductCategory_Name": productCategoryName,
    "ProductCategory_Description": productCategoryDescription,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
  };
}
