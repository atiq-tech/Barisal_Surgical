import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/employees_model.dart';

class EmployeesProvider extends ChangeNotifier {
  List<EmployeesModel> employeesList = [];
  getEmployees(BuildContext context) async {
    employeesList = await ApiService.fetchEmployeesApi(context);
    notifyListeners();
  }}