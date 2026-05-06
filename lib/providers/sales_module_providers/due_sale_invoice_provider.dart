import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/due_sale_invoice_model.dart';
import 'package:flutter/material.dart';

class DueSaleInvoiceProvider extends ChangeNotifier {
  static bool isDueSaleInvoiceLoading = false;
  List<DueSaleInvoiceModel> dueSaleInvoicelist = [];
  getDueSaleInvoice(BuildContext context, String? customerId) async {
    dueSaleInvoicelist = await ApiService.fetchDueSaleInvoiceApi(context, customerId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isDueSaleInvoiceLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isDueSaleInvoiceLoading = true;
    notifyListeners();
  }
}