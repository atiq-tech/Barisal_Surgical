import 'dart:convert';

class EmployeeAttendanceModel {
  final String employeeName;
  final DateTime? attendanceDate;
  final String inTime;
  final String outTime;

  EmployeeAttendanceModel({
    required this.employeeName,
    required this.attendanceDate,
    required this.inTime,
    required this.outTime,
  });

  /// 🔥 fromMap (Main)
  factory EmployeeAttendanceModel.fromMap(Map<String, dynamic> json) {
    return EmployeeAttendanceModel(
      employeeName: json["employee_name"] ?? "",

      /// ✅ safe date parsing (handles null + both key নাম)
      attendanceDate: DateTime.tryParse(
        json["attendanceDate"] ??
        json["attendance_date"] ??
        "",
      ),

      inTime: json["in_time"] ?? "",
      outTime: json["out_time"] ?? "",
    );
  }

  /// optional (if needed)
  factory EmployeeAttendanceModel.fromJson(String str) =>
      EmployeeAttendanceModel.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      "employee_name": employeeName,
      "attendanceDate":
          attendanceDate != null ? attendanceDate!.toIso8601String() : null,
      "in_time": inTime,
      "out_time": outTime,
    };
  }

  String toJson() => json.encode(toMap());
}

// class EmployeeAttendanceModel {
//     final dynamic employeeName;
//     final dynamic attendanceDate;
//     final dynamic inTime;
//     final dynamic outTime;

//     EmployeeAttendanceModel({
//         required this.employeeName,
//         required this.attendanceDate,
//         required this.inTime,
//         required this.outTime,
//     });

//     factory EmployeeAttendanceModel.fromJson(String str) => EmployeeAttendanceModel.fromMap(json.decode(str));

//     String toJson() => json.encode(toMap());

//     factory EmployeeAttendanceModel.fromMap(Map<String, dynamic> json) => EmployeeAttendanceModel(
//         employeeName: json["employee_name"],
//         attendanceDate: DateTime.parse(json["attendanceDate"]),
//         inTime: json["in_time"],
//         outTime: json["out_time"],
//     );

//     Map<String, dynamic> toMap() => {
//         "employee_name": employeeName,
//         "attendanceDate": attendanceDate,
//         "in_time": inTime,
//         "out_time": outTime,
//     };
// }
