import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_model.dart';

class SalesProvider extends ChangeNotifier {
  static bool isSalesLoading = false;
  List<SalesModel> saleslist = [];
  Future<void> getSales(BuildContext context,String? userId, String? customerId, String? employeeId, String? dateFrom, String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      saleslist = await ApiService.fetchSales(context,userId,customerId,employeeId,dateFrom,dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isSalesLoading = false;
    notifyListeners();
  }
  on(){
    isSalesLoading = true;
    notifyListeners();
  }
}
