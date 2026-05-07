import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/ecp_wise_sales_report_model.dart';
import 'package:flutter/material.dart';

class EcpWiseSaleReportProvider extends ChangeNotifier {
  static bool isEcpWiseSalesReportLoading = false;
  List<EcpWiseSalesReportModel> ecpWiseSalesReportlist = [];
  getEcpWiseSalesReport(BuildContext context,
    String? employeeId,
    String? customerId,
    String? productId, 
    String? dateFrom,
    String? dateTo) async {
    ecpWiseSalesReportlist = await ApiService.fetchEcpWiseSalesReportApi(context, employeeId,customerId,productId,dateFrom,dateTo);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isEcpWiseSalesReportLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isEcpWiseSalesReportLoading = true;
    notifyListeners();
  }
}