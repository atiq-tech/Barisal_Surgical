import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/invoice_due_model.dart';
import 'package:flutter/material.dart';

class InvoiceDueProvider extends ChangeNotifier {
  static bool isInvoiceDueLoading = false;
  List<InvoiceDueModel> invoiceDueList = [];
  Future<void> getInvoiceDue(BuildContext context,String? customerId) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      invoiceDueList = await ApiService.fetchInvoiceDue(context,customerId) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isInvoiceDueLoading = false;
    notifyListeners();
  }
  on(){
    isInvoiceDueLoading = true;
    notifyListeners();
  }
}
