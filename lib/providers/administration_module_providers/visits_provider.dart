
import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/visits_model.dart';
import 'package:flutter/material.dart';

class VisitsProvider extends ChangeNotifier {
  static bool isVisitsLoading = false;

  List<VisitsModel> visitsList = [];
  getVisits(BuildContext context,String? customerId,String? employeeId,String? dateFrom,String? dateTo) async {
    visitsList = await ApiService.fetchVisitApi(context, customerId, employeeId, dateFrom, dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isVisitsLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isVisitsLoading = true;
    notifyListeners();
  }
}