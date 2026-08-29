import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_payments_model.dart';
import 'package:flutter/material.dart';

class CustomerPaymentsProvider extends ChangeNotifier {
  static bool isCustomerPaymentsLoading = false;

  List<CustomerPaymentsModel> customerPaymentsList = [];
  Future<void> getCustomerPayments(BuildContext context,String? customerId,String? paymentType,String? employeeId,String? dateFrom,String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      customerPaymentsList = await ApiService.fetchCustomerPayments(context, customerId, paymentType, employeeId, dateFrom, dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isCustomerPaymentsLoading = false;
    notifyListeners();
  }
  on(){
    isCustomerPaymentsLoading = true;
    notifyListeners();
  }
}
