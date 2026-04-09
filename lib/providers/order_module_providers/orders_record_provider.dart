import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/order_module_models/orders_record_model.dart';
import 'package:flutter/material.dart';

class OrdersRecordProvider extends ChangeNotifier {
static bool isOrdersRecordLoading = false;

List<OrdersRecordModel> ordersRecordlist = [];
 getOrdersRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
   ordersRecordlist = await ApiService.fetchOrdersRecord(context,userId,customerId,employeeId,dateFrom,dateTo);
   off();
   notifyListeners();
}

 off(){
 Future.delayed(const Duration(seconds: 1),() {
 print('off');
   isOrdersRecordLoading = false;
    notifyListeners();
  });
}
 on(){
 print('on');
  isOrdersRecordLoading = true;
   notifyListeners();
  }
}