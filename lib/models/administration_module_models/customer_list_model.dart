import 'dart:convert';

class CustomerListModel {
  final dynamic customerSlNo;
  final dynamic employeeId;
  final dynamic customerCode;
  final dynamic customerName;
  final dynamic customerType;
  final dynamic customerPhone;
  final dynamic customerMobile;
  final dynamic customerEmail;
  final dynamic customerOfficePhone;
  final dynamic customerAddress;
  final dynamic ownerName;
  final dynamic countrySlNo;
  final dynamic areaId;
  final dynamic customerWeb;
  final dynamic customerCreditLimit;
  final dynamic previousDue;
  final dynamic imageName;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic dealerId;
  final dynamic branchId;
  final dynamic districtName;
  final dynamic displayName;
  final dynamic employeeName;
  final dynamic tsmName;
  final dynamic asmName;
  final dynamic rsmName;
  final dynamic nsmName;
  final dynamic addedBy;
  final dynamic customerListModelDeletedBy;

  CustomerListModel({
    this.customerSlNo,
    this.employeeId,
    this.customerCode,
    this.customerName,
    this.customerType,
    this.customerPhone,
    this.customerMobile,
    this.customerEmail,
    this.customerOfficePhone,
    this.customerAddress,
    this.ownerName,
    this.countrySlNo,
    this.areaId,
    this.customerWeb,
    this.customerCreditLimit,
    this.previousDue,
    this.imageName,
    this.status,
    this.addBy,
    this.addTime,
    this.updateBy,
    this.updateTime,
    this.deletedBy,
    this.deletedTime,
    this.lastUpdateIp,
    this.dealerId,
    this.branchId,
    this.districtName,
    this.displayName,
    this.employeeName,
    this.tsmName,
    this.asmName,
    this.rsmName,
    this.nsmName,
    this.addedBy,
    this.customerListModelDeletedBy,
  });

  factory CustomerListModel.fromJson(String str) => CustomerListModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory CustomerListModel.fromMap(Map<String, dynamic> json) => CustomerListModel(
    customerSlNo: json["Customer_SlNo"],
    employeeId: json["employee_id"],
    customerCode: json["Customer_Code"],
    customerName: json["Customer_Name"],
    customerType: json["Customer_Type"],
    customerPhone: json["Customer_Phone"],
    customerMobile: json["Customer_Mobile"],
    customerEmail: json["Customer_Email"],
    customerOfficePhone: json["Customer_OfficePhone"],
    customerAddress: json["Customer_Address"],
    ownerName: json["owner_name"],
    countrySlNo: json["Country_SlNo"],
    areaId: json["area_ID"],
    customerWeb: json["Customer_Web"],
    customerCreditLimit: json["Customer_Credit_Limit"],
    previousDue: json["previous_due"],
    imageName: json["image_name"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    dealerId: json["dealerId"],
    branchId: json["branch_id"],
    districtName: json["District_Name"],
    displayName: json["display_name"],
    employeeName: json["Employee_Name"],
    tsmName: json["tsm_name"],
    asmName: json["asm_name"],
    rsmName: json["rsm_name"],
    nsmName: json["nsm_name"],
    addedBy: json["added_by"],
    customerListModelDeletedBy: json["deleted_by"],
  );

  Map<String, dynamic> toMap() => {
    "Customer_SlNo": customerSlNo,
    "employee_id": employeeId,
    "Customer_Code": customerCode,
    "Customer_Name": customerName,
    "Customer_Type": customerType,
    "Customer_Phone": customerPhone,
    "Customer_Mobile": customerMobile,
    "Customer_Email": customerEmail,
    "Customer_OfficePhone": customerOfficePhone,
    "Customer_Address": customerAddress,
    "owner_name": ownerName,
    "Country_SlNo": countrySlNo,
    "area_ID": areaId,
    "Customer_Web": customerWeb,
    "Customer_Credit_Limit": customerCreditLimit,
    "previous_due": previousDue,
    "image_name": imageName,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "dealerId": dealerId,
    "branch_id": branchId,
    "District_Name": districtName,
    "display_name": displayName,
    "Employee_Name": employeeName,
    "tsm_name": tsmName,
    "asm_name": asmName,
    "rsm_name": rsmName,
    "nsm_name": nsmName,
    "added_by": addedBy,
    "deleted_by": customerListModelDeletedBy,
  };
}
