import 'package:flutter/cupertino.dart';
import 'package:barishal_surgical/models/sales_module_models/expire_stock_model.dart';
import '../../api_services/api_service.dart';

class ExpireStockProvider extends ChangeNotifier {
  static bool isExpireStockLoading = false;
  List<ExpireStockModel> expireStockList = [];
  Future<void> getExpireStock(BuildContext context,String? productId) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      expireStockList = await ApiService.fetchExpireStockApi(context,productId) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isExpireStockLoading = false;
    notifyListeners();
  }
  on(){
    isExpireStockLoading = true;
    notifyListeners();
  }
}
