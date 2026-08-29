import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_details_model.dart';
import 'package:flutter/material.dart';

class OrdersDetailsProvider extends ChangeNotifier {
  static bool isOrdersDetailsLoading = false;
  List<OrdersDetailsModel> ordersDetailslist = [];
  Future<void> getOrdersDetails(BuildContext context,String? categoryId,String? productId, String? dateFrom, String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      ordersDetailslist = await ApiService.fetchOrdersDetails(context,categoryId,productId,dateFrom,dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isOrdersDetailsLoading = false;
    notifyListeners();
  }
  on(){
    isOrdersDetailsLoading = true;
    notifyListeners();
  }
}
