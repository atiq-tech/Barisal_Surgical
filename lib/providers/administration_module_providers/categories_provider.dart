import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  static bool isCategoriesListLoading = false;
  List<CategoriesModel> categoriesList = [];
  getCategoriesList(BuildContext context) async {
    categoriesList = await ApiService.fetchCategoriesListApi(context);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isCategoriesListLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isCategoriesListLoading = true;
    notifyListeners();
  }
}