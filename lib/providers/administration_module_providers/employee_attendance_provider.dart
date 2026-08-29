import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/employee_attendance_model.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceProvider extends ChangeNotifier {
  static bool isEmployeeAttendanceLoading = false;

  List<EmployeeAttendanceModel> employeeAttendanceList = [];
  Future<void> getEmployeeAttendance(BuildContext context,String? employeeId,String? dateFrom,String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      employeeAttendanceList = await ApiService.fetchEmployeeAttendance(context, employeeId, dateFrom, dateTo);
    } finally {
      off();
    }
  }
  off(){
    isEmployeeAttendanceLoading = false;
    notifyListeners();
  }
  on(){
    isEmployeeAttendanceLoading = true;
    notifyListeners();
  }
}
