import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/emp_wise_cus_pay_due_model.dart';
import 'package:flutter/material.dart';

class EmpWiseCusPayDueProvider extends ChangeNotifier {
  static bool isEmpWiseCusPayDueLoading = false;
  List<EmpWiseCusPayDueModel> empWiseCusPayDuelist = [];
  getEmpWiseCusPayDue(BuildContext context, 
    String? customerId,
    String? employeeId,
    String? searchType,
    String? paymentType,
    String? dateFrom,
    String? dateTo) async {
    empWiseCusPayDuelist = await ApiService.fetchEmpWiseCusPayDueApi(context, 
        customerId, 
        employeeId, 
        searchType, 
        paymentType, 
        dateFrom, 
        dateTo
    );
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isEmpWiseCusPayDueLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isEmpWiseCusPayDueLoading = true;
    notifyListeners();
  }
}