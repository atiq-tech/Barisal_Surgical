import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier {
  static bool isOrdersLoading = false;
  List<OrdersModel> orderslist = [];
  getOrders(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
    orderslist = await ApiService.fetchOrders(context,userId,customerId,employeeId,dateFrom,dateTo);
    off();
    notifyListeners();
  }

  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isOrdersLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isOrdersLoading = true;
    notifyListeners();
  }
}