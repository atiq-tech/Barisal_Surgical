import 'package:flutter/cupertino.dart';
import 'package:barishal_surgical/models/sales_module_models/expire_stock_model.dart';
import '../../api_services/api_service.dart';

class ExpireStockProvider extends ChangeNotifier {
  static bool isExpireStockLoading = false;
  List<ExpireStockModel> expireStockList = [];
  getExpireStock(BuildContext context,String? productId) async {
    expireStockList = await ApiService.fetchExpireStockApi(context,productId);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isExpireStockLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isExpireStockLoading = true;
    notifyListeners();
  }
}