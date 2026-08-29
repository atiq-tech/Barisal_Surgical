
import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/visits_model.dart';
import 'package:flutter/material.dart';

class VisitsProvider extends ChangeNotifier {
  static bool isVisitsLoading = false;

  List<VisitsModel> visitsList = [];
  Future<void> getVisits(BuildContext context,String? customerId,String? employeeId,String? dateFrom,String? dateTo) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      visitsList = await ApiService.fetchVisitApi(context, customerId, employeeId, dateFrom, dateTo) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isVisitsLoading = false;
    notifyListeners();
  }
  on(){
    isVisitsLoading = true;
    notifyListeners();
  }
}
