import 'package:flutter/material.dart';
import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/sales_module_models/bank_account_model.dart';

class BankAccountProvider extends ChangeNotifier {
  static bool isBankAccountLoading = false;
  List<BankAccountModel> bankAccountList = [];
  Future<void> getBankAccount(BuildContext context) async {
    await Future<void>.delayed(Duration.zero);
    on();
    try {
      bankAccountList = await ApiService.fetchBankAccount(context) ?? [];
    } finally {
      off();
    }
  }
  off(){
    isBankAccountLoading = false;
    notifyListeners();
  }
  on(){
    isBankAccountLoading = true;
    notifyListeners();
  }
}
