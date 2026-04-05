import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_invoice_model.dart';

class SalesInvoiceProvider extends ChangeNotifier {

  SalesInvoiceModel? salesInvoiceModel;
  Future<SalesInvoiceModel?>getSalesInvoice(context, String? salesId) async {
    salesInvoiceModel = await ApiService.fetchSalesInvoice(salesId);
    return salesInvoiceModel;
  }
}

