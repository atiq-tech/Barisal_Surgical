import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_details_model.dart';
import 'package:flutter/material.dart';

class OrdersDetailsProvider extends ChangeNotifier {
  static bool isOrdersDetailsLoading = false;
  List<OrdersDetailsModel> ordersDetailslist = [];
  getOrdersDetails(BuildContext context,String? categoryId,String? productId, String? dateFrom, String? dateTo) async {
    ordersDetailslist = await ApiService.fetchOrdersDetails(context,categoryId,productId,dateFrom,dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('off');
      isOrdersDetailsLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('on');
    isOrdersDetailsLoading = true;
    notifyListeners();
  }
}