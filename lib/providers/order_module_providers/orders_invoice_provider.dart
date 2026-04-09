import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_invoice_model.dart';
import 'package:flutter/material.dart';

class OrdersInvoiceProvider extends ChangeNotifier {
  
  OrdersInvoiceModel? ordersInvoiceModel;
  Future<OrdersInvoiceModel?>getOrdersInvoice(context, String? salesId) async {
    ordersInvoiceModel = await ApiService.fetchOrdersInvoice(salesId);
    return ordersInvoiceModel;
  }
}
