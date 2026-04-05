import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_record_model.dart';

class SalesRecordProvider extends ChangeNotifier {
static bool isSalesRecordLoading = false;

List<SalesRecordModel> salesRecordlist = [];
 getSalesRecord(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
   salesRecordlist = await ApiService.fetchSalesRecord(context,userId,customerId,employeeId,dateFrom,dateTo);
   off();
   notifyListeners();
}

 off(){
 Future.delayed(const Duration(seconds: 1),() {
 print('off');
   isSalesRecordLoading = false;
    notifyListeners();
  });
}
 on(){
 print('on');
  isSalesRecordLoading = true;
   notifyListeners();
  }
}