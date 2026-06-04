import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/customer_payments_model.dart';
import 'package:flutter/material.dart';

class CustomerPaymentsProvider extends ChangeNotifier {
  static bool isCustomerPaymentsLoading = false;

  List<CustomerPaymentsModel> customerPaymentsList = [];
  getCustomerPayments(BuildContext context,String? customerId,String? paymentType,String? employeeId,String? dateFrom,String? dateTo) async {
    customerPaymentsList = await ApiService.fetchCustomerPayments(context, customerId, paymentType, employeeId, dateFrom, dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCustomerPaymentsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCustomerPaymentsLoading = true;
    notifyListeners();
  }
}