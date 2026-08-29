import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/sales_module_models/total_stock_model.dart';

class TotalStockProvider extends ChangeNotifier {
  static bool isTotalStockLoading = false;
  List<TotalStockModel> totalStockList = [];
  Future<void> getTotalStock(BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      totalStockList = await ApiService.fetchTotalStockApi(context) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isTotalStockLoading = false;
    notifyListeners();
  }
  on(){
    isTotalStockLoading = true;
    notifyListeners();
  }
}
