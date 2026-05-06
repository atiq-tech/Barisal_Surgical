import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/customer_due_model.dart';
import 'package:flutter/material.dart';

class CustomerDueProvider extends ChangeNotifier {
  static bool isCustomerDueLoading = false;
  List<CustomerDueModel> customerDuelist = [];
  getCustomerDue(BuildContext context, String? customerId,String? districtId,String? salesId) async {
    customerDuelist = await ApiService.fetchCustomerDueApi(context, customerId, districtId, salesId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCustomerDueLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isCustomerDueLoading = true;
    notifyListeners();
  }
}