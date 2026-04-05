import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_model.dart';

class SalesProvider extends ChangeNotifier {
  static bool isSalesLoading = false;
  List<SalesModel> saleslist = [];
  getSales(BuildContext context,String? userId, String? customerId, String? employeeId, String? branchId, String? dateFrom, String? dateTo) async {
    saleslist = await ApiService.fetchSales(context,userId,customerId,employeeId,branchId,dateFrom,dateTo);
    off();
    notifyListeners();
  }

  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isSalesLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isSalesLoading = true;
    notifyListeners();
  }
}