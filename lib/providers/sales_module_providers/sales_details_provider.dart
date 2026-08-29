import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_details_model.dart';

class SalesDetailsProvider extends ChangeNotifier {
  static bool isSalesDetailsLoading = false;
  List<SalesDetailsModel> salesDetailslist = [];
  Future<void> getSalesDetails(BuildContext context,String? categoryId,String? productId,String? employeeId, String? dateFrom, String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      salesDetailslist = await ApiService.fetchSalesDetails(context,categoryId,productId,employeeId,dateFrom,dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isSalesDetailsLoading = false;
    notifyListeners();
  }
  on(){
    isSalesDetailsLoading = true;
    notifyListeners();
  }
}
