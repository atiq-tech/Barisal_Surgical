import 'dart:convert';

class VisitsModel {
    final dynamic id;
    final dynamic date;
    final dynamic employeeId;
    final dynamic customerId;
    final dynamic location;
    final dynamic remark;
    final dynamic latitude;
    final dynamic longitude;
    final dynamic status;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic customerName;
    final dynamic customerMobile;
    final dynamic employeeName;

    VisitsModel({
        required this.id,
        required this.date,
        required this.employeeId,
        required this.customerId,
        required this.location,
        required this.remark,
        required this.latitude,
        required this.longitude,
        required this.status,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.customerName,
        required this.customerMobile,
        required this.employeeName,
    });

    factory VisitsModel.fromJson(String str) => VisitsModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory VisitsModel.fromMap(Map<String, dynamic> json) => VisitsModel(
        id: json["id"],
        date: json["date"],
        employeeId: json["employee_id"],
        customerId: json["customer_id"],
        location: json["location"],
        remark: json["remark"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        status: json["status"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        customerName: json["Customer_Name"],
        customerMobile: json["Customer_Mobile"],
        employeeName: json["Employee_Name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "date": date,
        "employee_id": employeeId,
        "customer_id": customerId,
        "location": location,
        "remark": remark,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Customer_Name": customerName,
        "Customer_Mobile": customerMobile,
        "Employee_Name": employeeName,
    };
}
