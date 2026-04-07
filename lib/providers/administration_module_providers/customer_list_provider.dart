import 'package:flutter/material.dart';
import '../../api_services/api_service.dart';
import '../../models/administration_module_models/customer_list_model.dart';

class CustomerListProvider extends ChangeNotifier {
  List<CustomerListModel> customerList = [];
  static bool isCustomerListloading = false;

  getCustomerList(BuildContext context,String? customerType,String? employeeId) async {
    customerList = await ApiService.fetchCustomerListApi(context, customerType, employeeId);
    customerList.insert(0, CustomerListModel(customerSlNo: 0,customerCode:"",displayName:"Cash Customer",customerName: "Cash Customer", customerType: "G", customerMobile: ""));
    customerList.insert(1, CustomerListModel(customerSlNo: 0,customerCode:"",displayName:"New Customer",customerName: "New Customer", customerType: "N", customerMobile: ""));
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('off');
      isCustomerListloading = false;
      notifyListeners();
    },);
  }
  on(){
    print('on');
    isCustomerListloading = true;
    notifyListeners();
  }
}