import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_record_model.dart';
import 'package:flutter/material.dart';

class OrdersRecordProvider extends ChangeNotifier {
static bool isOrdersRecordLoading = false;

List<OrdersRecordModel> ordersRecordlist = [];
 Future<void> getOrdersRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
   await Future<void>.delayed(Duration.zero);
   on();
   try {
     ordersRecordlist = await ApiService.fetchOrdersRecord(context,userId,customerId,employeeId,dateFrom,dateTo) ?? [];
   } finally {
     off();
   }
}
  off(){
    isOrdersRecordLoading = false;
    notifyListeners();
  }
  on(){
    isOrdersRecordLoading = true;
    notifyListeners();
  }
}
