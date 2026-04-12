import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/invoice_due_model.dart';
import 'package:flutter/material.dart';

class InvoiceDueProvider extends ChangeNotifier {
  static bool isInvoiceDueLoading = false;
  List<InvoiceDueModel> invoiceDueList = [];
  getInvoiceDue(BuildContext context,String? customerId) async {
    invoiceDueList = await ApiService.fetchInvoiceDue(context,customerId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isInvoiceDueLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isInvoiceDueLoading = true;
    notifyListeners();
  }
}