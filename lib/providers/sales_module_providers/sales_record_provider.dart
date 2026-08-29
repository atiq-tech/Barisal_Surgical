import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_record_model.dart';

class SalesRecordProvider extends ChangeNotifier {
static bool isSalesRecordLoading = false;

List<SalesRecordModel> salesRecordlist = [];
 Future<void> getSalesRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
   await Future<void>.delayed(Duration.zero);
   on();
   try {
     salesRecordlist = await ApiService.fetchSalesRecord(context,userId,customerId,employeeId,dateFrom,dateTo) ?? [];
   } finally {
     off();
   }
}
  off(){
    isSalesRecordLoading = false;
    notifyListeners();
  }
  on(){
    isSalesRecordLoading = true;
    notifyListeners();
  }
}
