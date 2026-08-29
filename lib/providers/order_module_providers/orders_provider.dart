import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier {
  static bool isOrdersLoading = false;
  List<OrdersModel> orderslist = [];
  Future<void> getOrders(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      orderslist = await ApiService.fetchOrders(context,userId,customerId,employeeId,dateFrom,dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isOrdersLoading = false;
    notifyListeners();
  }
  on(){
    isOrdersLoading = true;
    notifyListeners();
  }
}
