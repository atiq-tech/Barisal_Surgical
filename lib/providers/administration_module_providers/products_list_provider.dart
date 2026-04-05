import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/product_list_model.dart';

class ProductListProvider extends ChangeNotifier {
  static bool isProductsListLoading = false;

  List<ProductListModel> productsList = [];
  getProductList(BuildContext context) async {
    productsList = await ApiService.fetchProductListApi(context);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('off');
      isProductsListLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('on');
    isProductsListLoading = true;
    notifyListeners();
  }
}