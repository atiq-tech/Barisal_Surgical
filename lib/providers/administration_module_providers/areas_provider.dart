import 'package:flutter/cupertino.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/areas_model.dart';

class AreasProvider extends ChangeNotifier {
  List<AreasModel> areasList = [];
  getAreas(BuildContext context) async {
    areasList = await ApiService.fetchAreasApi(context);
    notifyListeners();
}}