import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/employee_attendance_model.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceProvider extends ChangeNotifier {
  static bool isEmployeeAttendanceLoading = false;

  List<EmployeeAttendanceModel> employeeAttendanceList = [];
  getEmployeeAttendance(BuildContext context,String? employeeId,String? dateFrom,String? dateTo) async {
    employeeAttendanceList = await ApiService.fetchEmployeeAttendance(context, employeeId, dateFrom, dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isEmployeeAttendanceLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isEmployeeAttendanceLoading = true;
    notifyListeners();
  }
}