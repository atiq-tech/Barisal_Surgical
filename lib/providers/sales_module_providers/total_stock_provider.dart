import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/total_stock_model.dart';

class TotalStockProvider extends ChangeNotifier {
  static bool isTotalStockLoading = false;
  List<TotalStockModel> totalStockList = [];
  getTotalStock(BuildContext context) async {
    totalStockList = await ApiService.fetchTotalStockApi(context);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isTotalStockLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isTotalStockLoading = true;
    notifyListeners();
  }
}