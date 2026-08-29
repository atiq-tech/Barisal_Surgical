import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/customer_due_model.dart';
import 'package:flutter/material.dart';

class CustomerDueProvider extends ChangeNotifier {
  static bool isCustomerDueLoading = false;
  List<CustomerDueModel> customerDuelist = [];
  Future<void> getCustomerDue(BuildContext context, String? customerId,String? districtId,String? salesId) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      customerDuelist = await ApiService.fetchCustomerDueApi(context, customerId, districtId, salesId) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isCustomerDueLoading = false;
    notifyListeners();
  }
  on(){
    isCustomerDueLoading = true;
    notifyListeners();
  }
}
