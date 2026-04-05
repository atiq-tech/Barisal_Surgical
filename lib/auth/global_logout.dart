import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:barishal_surgical/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/const_model.dart';
import 'global_function.dart';

class LogoutService{
  static Future<void> fetchLogout(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String link = "${baseUrl}logout";
      Response response = await Dio().get(link,
          options: Options(headers: {
            "Content-Type": "application/json",
            'Cookie': 'ci_session=${sharedPreferences.getString("sessionId")}',
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = response.data;
      print("Logout Response: $item");
      if (item['success'] == true) {
        Utils.showMotionToast(
          context,
          title: "${item["message"]}!",
          description: "Welcome to the Login Page",
          icon: Icons.check_circle,
          duration: const Duration(seconds: 3),
        );
        AuthHelper.userLogout();
      } else {
        if (item['status'] == 401) {
          AuthHelper.userLogout();
        }
      }
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
