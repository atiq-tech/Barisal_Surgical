import 'dart:convert';

class EmployeesModel {
  final dynamic employeeSlNo;
  final dynamic assignOn;
  final dynamic positionId;
  final dynamic designationId;
  final dynamic reportingbossId;
  final dynamic nsmId;
  final dynamic rsmId;
  final dynamic asmId;
  final dynamic tsmId;
  final dynamic departmentId;
  final dynamic employeeId;
  final dynamic bioId;
  final dynamic employeeName;
  final dynamic employeeJoinDate;
  final dynamic employeeGender;
  final dynamic employeeBirthDate;
  final dynamic employeeNid;
  final dynamic employeeContactNo;
  final dynamic employeeEmail;
  final dynamic employeeMaritalStatus;
  final dynamic employeeFatherName;
  final dynamic employeeMotherName;
  final dynamic employeePrasentAddress;
  final dynamic employeePermanentAddress;
  final dynamic employeePicOrg;
  final dynamic employeePicThum;
  final dynamic salaryRange;
  final dynamic employeeReference;
  final dynamic status;
  final dynamic addBy;
  final dynamic addTime;
  final dynamic updateBy;
  final dynamic updateTime;
  final dynamic deletedBy;
  final dynamic deletedTime;
  final dynamic lastUpdateIp;
  final dynamic branchId;
  final dynamic departmentName;
  final dynamic designationName;
  final dynamic displayName;
  final dynamic tsmName;
  final dynamic asmName;
  final dynamic rsmName;
  final dynamic nsmName;
  final dynamic assignName;

  EmployeesModel({
    required this.employeeSlNo,
    required this.assignOn,
    required this.positionId,
    required this.designationId,
    required this.reportingbossId,
    required this.nsmId,
    required this.rsmId,
    required this.asmId,
    required this.tsmId,
    required this.departmentId,
    required this.employeeId,
    required this.bioId,
    required this.employeeName,
    required this.employeeJoinDate,
    required this.employeeGender,
    required this.employeeBirthDate,
    required this.employeeNid,
    required this.employeeContactNo,
    required this.employeeEmail,
    required this.employeeMaritalStatus,
    required this.employeeFatherName,
    required this.employeeMotherName,
    required this.employeePrasentAddress,
    required this.employeePermanentAddress,
    required this.employeePicOrg,
    required this.employeePicThum,
    required this.salaryRange,
    required this.employeeReference,
    required this.status,
    required this.addBy,
    required this.addTime,
    required this.updateBy,
    required this.updateTime,
    required this.deletedBy,
    required this.deletedTime,
    required this.lastUpdateIp,
    required this.branchId,
    required this.departmentName,
    required this.designationName,
    required this.displayName,
    required this.tsmName,
    required this.asmName,
    required this.rsmName,
    required this.nsmName,
    required this.assignName,
  });

  factory EmployeesModel.fromJson(String str) => EmployeesModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory EmployeesModel.fromMap(Map<String, dynamic> json) => EmployeesModel(
    employeeSlNo: json["Employee_SlNo"],
    assignOn: json["assign_on"],
    positionId: json["positionId"],
    designationId: json["Designation_ID"],
    reportingbossId: json["reportingbossId"],
    nsmId: json["NSM_ID"],
    rsmId: json["RSM_ID"],
    asmId: json["ASM_ID"],
    tsmId: json["TSM_ID"],
    departmentId: json["Department_ID"],
    employeeId: json["Employee_ID"],
    bioId: json["bio_id"],
    employeeName: json["Employee_Name"],
    employeeJoinDate: json["Employee_JoinDate"],
    employeeGender: json["Employee_Gender"],
    employeeBirthDate: json["Employee_BirthDate"],
    employeeNid: json["Employee_NID"],
    employeeContactNo: json["Employee_ContactNo"],
    employeeEmail: json["Employee_Email"],
    employeeMaritalStatus: json["Employee_MaritalStatus"],
    employeeFatherName: json["Employee_FatherName"],
    employeeMotherName: json["Employee_MotherName"],
    employeePrasentAddress: json["Employee_PrasentAddress"],
    employeePermanentAddress: json["Employee_PermanentAddress"],
    employeePicOrg: json["Employee_Pic_org"],
    employeePicThum: json["Employee_Pic_thum"],
    salaryRange: json["salary_range"],
    employeeReference: json["Employee_Reference"],
    status: json["status"],
    addBy: json["AddBy"],
    addTime: json["AddTime"],
    updateBy: json["UpdateBy"],
    updateTime: json["UpdateTime"],
    deletedBy: json["DeletedBy"],
    deletedTime: json["DeletedTime"],
    lastUpdateIp: json["last_update_ip"],
    branchId: json["branch_id"],
    departmentName: json["Department_Name"],
    designationName: json["Designation_Name"],
    displayName: json["display_name"],
    tsmName: json["tsm_name"],
    asmName: json["asm_name"],
    rsmName: json["rsm_name"],
    nsmName: json["nsm_name"],
    assignName: json["Assign_Name"],
  );

  Map<String, dynamic> toMap() => {
    "Employee_SlNo": employeeSlNo,
    "assign_on": assignOn,
    "positionId": positionId,
    "Designation_ID": designationId,
    "reportingbossId": reportingbossId,
    "NSM_ID": nsmId,
    "RSM_ID": rsmId,
    "ASM_ID": asmId,
    "TSM_ID": tsmId,
    "Department_ID": departmentId,
    "Employee_ID": employeeId,
    "bio_id": bioId,
    "Employee_Name": employeeName,
    "Employee_JoinDate": employeeJoinDate,
    "Employee_Gender": employeeGender,
    "Employee_BirthDate": employeeBirthDate,
    "Employee_NID": employeeNid,
    "Employee_ContactNo": employeeContactNo,
    "Employee_Email": employeeEmail,
    "Employee_MaritalStatus": employeeMaritalStatus,
    "Employee_FatherName": employeeFatherName,
    "Employee_MotherName": employeeMotherName,
    "Employee_PrasentAddress": employeePrasentAddress,
    "Employee_PermanentAddress": employeePermanentAddress,
    "Employee_Pic_org": employeePicOrg,
    "Employee_Pic_thum": employeePicThum,
    "salary_range": salaryRange,
    "Employee_Reference": employeeReference,
    "status": status,
    "AddBy": addBy,
    "AddTime": addTime,
    "UpdateBy": updateBy,
    "UpdateTime": updateTime,
    "DeletedBy": deletedBy,
    "DeletedTime": deletedTime,
    "last_update_ip": lastUpdateIp,
    "branch_id": branchId,
    "Department_Name": departmentName,
    "Designation_Name": designationName,
    "display_name": displayName,
    "tsm_name": tsmName,
    "asm_name": asmName,
    "rsm_name": rsmName,
    "nsm_name": nsmName,
    "Assign_Name": assignName,
  };
}
