import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/due_sale_invoice_model.dart';
import 'package:flutter/material.dart';

class DueSaleInvoiceProvider extends ChangeNotifier {
  static bool isDueSaleInvoiceLoading = false;
  List<DueSaleInvoiceModel> dueSaleInvoicelist = [];
  Future<void> getDueSaleInvoice(BuildContext context, String? customerId) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      dueSaleInvoicelist = await ApiService.fetchDueSaleInvoiceApi(context, customerId) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isDueSaleInvoiceLoading = false;
    notifyListeners();
  }
  on(){
    isDueSaleInvoiceLoading = true;
    notifyListeners();
  }
}
