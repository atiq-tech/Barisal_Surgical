import 'package:barishal_surgical/api_services/api_service.dart';
import 'package:barishal_surgical/models/administration_module_models/users_model.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  List<UsersModel> usersList = [];
  getUsers(BuildContext context) async {
    usersList = await ApiService.fetchUsersApi(context);
    notifyListeners();
  }}