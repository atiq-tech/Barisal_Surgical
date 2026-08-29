import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/product_list_model.dart';

class ProductListProvider extends ChangeNotifier {
  static bool isProductsListLoading = false;

  List<ProductListModel> productsList = [];
  Future<void> getProductList(BuildContext context,String? customerId) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      productsList = await ApiService.fetchProductListApi(context,customerId) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isProductsListLoading = false;
    notifyListeners();
  }
  on(){
    isProductsListLoading = true;
    notifyListeners();
  }
}
