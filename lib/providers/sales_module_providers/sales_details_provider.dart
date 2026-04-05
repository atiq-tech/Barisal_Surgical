import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/sales_details_model.dart';

class SalesDetailsProvider extends ChangeNotifier {
  static bool isSalesDetailsLoading = false;
  List<SalesDetailsModel> salesDetailslist = [];
  getSalesDetails(BuildContext context,String? categoryId,String? productId,String? userId, String? branchId, String? dateFrom, String? dateTo) async {
    salesDetailslist = await ApiService.fetchSalesDetails(context,categoryId,productId,userId,branchId,dateFrom,dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('off');
      isSalesDetailsLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('on');
    isSalesDetailsLoading = true;
    notifyListeners();
  }
}