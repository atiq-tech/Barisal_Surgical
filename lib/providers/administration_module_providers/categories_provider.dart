import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/categories_model.dart';

class CategoriesProvider extends ChangeNotifier {
  static bool isCategoriesListLoading = false;
  List<CategoriesModel> categoriesList = [];
  Future<void> getCategoriesList(BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      categoriesList = await ApiService.fetchCategoriesListApi(context) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isCategoriesListLoading = false;
    notifyListeners();
  }
  on(){
    isCategoriesListLoading = true;
    notifyListeners();
  }
}
