import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/branches_model.dart';

class BranchesProvider extends ChangeNotifier {
  List<BranchesModel> branchesList = [];
  getBranches(BuildContext context) async {
    branchesList = await ApiService.fetchBranchesApi(context);
    notifyListeners();
  }}