import 'package:flutter/material.dart';
import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {
  static bool isBankAccountLoading = false;
  List<BankAccountModel> bankAccountList = [];
  getBankAccount(BuildContext context) async {
    bankAccountList = await ApiService.fetchBankAccount(context);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(const Duration(seconds: 1),() {
      print('offff');
      isBankAccountLoading = false;
      notifyListeners();
    });
  }
  on(){
    print('onnn');
    isBankAccountLoading = true;
    notifyListeners();
  }
}