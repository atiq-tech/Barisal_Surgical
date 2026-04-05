import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login_screen.dart';
class AuthHelper{
  static Future<void>userLogout() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      await GetStorage().erase();
      var box = await Hive.openBox('profile');
      await box.clear();
      print("User data cleared, redirecting to login......");
      /// Login Page-এ Redirect
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LogInPage()), (route) => false,
      // );
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LogInPage()),(route) => false,
      );
    } catch (e) {
      print("Error clearing user data: $e");
    }
  }
}

class SnackbarHelper {
  static void showSnackbar(String message) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade900,
          content: Center(
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }
  }
}

class ErrorSnackbarHelper {
  static void showSnackbar(String message) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade900.withOpacity(0.8),
          content: Center(
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: 20.w, right: 20.w,bottom: 600.h),
          duration: Duration(seconds: 3),
      ));
    }
  }
}



