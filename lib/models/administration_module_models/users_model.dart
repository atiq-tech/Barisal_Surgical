import 'dart:convert';

class UsersModel {
    final dynamic userSlNo;
    final dynamic userId;
    final dynamic fullName;
    final dynamic userName;
    final dynamic userEmail;
    final dynamic employeeId;
    final dynamic userBranchId;
    final dynamic userPassword;
    final dynamic userType;
    final dynamic token;
    final dynamic status;
    final dynamic verifycode;
    final dynamic imageName;
    final dynamic addBy;
    final dynamic addTime;
    final dynamic updateBy;
    final dynamic updateTime;
    final dynamic deletedBy;
    final dynamic deletedTime;
    final dynamic lastUpdateIp;
    final dynamic branchId;
    final dynamic employeeName;
    final dynamic branchName;

    UsersModel({
        required this.userSlNo,
        required this.userId,
        required this.fullName,
        required this.userName,
        required this.userEmail,
        required this.employeeId,
        required this.userBranchId,
        required this.userPassword,
        required this.userType,
        required this.token,
        required this.status,
        required this.verifycode,
        required this.imageName,
        required this.addBy,
        required this.addTime,
        required this.updateBy,
        required this.updateTime,
        required this.deletedBy,
        required this.deletedTime,
        required this.lastUpdateIp,
        required this.branchId,
        required this.employeeName,
        required this.branchName,
    });

    factory UsersModel.fromJson(String str) => UsersModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UsersModel.fromMap(Map<String, dynamic> json) => UsersModel(
        userSlNo: json["User_SlNo"],
        userId: json["User_ID"],
        fullName: json["FullName"],
        userName: json["User_Name"],
        userEmail: json["UserEmail"],
        employeeId: json["employee_id"],
        userBranchId: json["userBranch_id"],
        userPassword: json["User_Password"],
        userType: json["UserType"],
        token: json["token"],
        status: json["status"],
        verifycode: json["verifycode"],
        imageName: json["image_name"],
        addBy: json["AddBy"],
        addTime: json["AddTime"],
        updateBy: json["UpdateBy"],
        updateTime: json["UpdateTime"],
        deletedBy: json["DeletedBy"],
        deletedTime: json["DeletedTime"],
        lastUpdateIp: json["last_update_ip"],
        branchId: json["branch_id"],
        employeeName: json["Employee_Name"],
        branchName: json["Branch_name"],
    );

    Map<String, dynamic> toMap() => {
        "User_SlNo": userSlNo,
        "User_ID": userId,
        "FullName": fullName,
        "User_Name": userName,
        "UserEmail": userEmail,
        "employee_id": employeeId,
        "userBranch_id": userBranchId,
        "User_Password": userPassword,
        "UserType": userType,
        "token": token,
        "status": status,
        "verifycode": verifycode,
        "image_name": imageName,
        "AddBy": addBy,
        "AddTime": addTime,
        "UpdateBy": updateBy,
        "UpdateTime": updateTime,
        "DeletedBy": deletedBy,
        "DeletedTime": deletedTime,
        "last_update_ip": lastUpdateIp,
        "branch_id": branchId,
        "Employee_Name": employeeName,
        "Branch_name": branchName,
    };
}
